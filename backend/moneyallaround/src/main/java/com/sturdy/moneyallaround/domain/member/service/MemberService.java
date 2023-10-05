package com.sturdy.moneyallaround.domain.member.service;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;
import com.sturdy.moneyallaround.Exception.model.TokenCheckFailException;
import com.sturdy.moneyallaround.Exception.model.TokenNotFoundException;
import com.sturdy.moneyallaround.Exception.model.UserAuthException;
import com.sturdy.moneyallaround.Exception.model.UserException;
import com.sturdy.moneyallaround.config.security.jwt.TokenInfo;
import com.sturdy.moneyallaround.config.security.jwt.TokenProvider;
import com.sturdy.moneyallaround.domain.member.dto.request.*;
import com.sturdy.moneyallaround.domain.member.dto.response.*;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import com.sturdy.moneyallaround.domain.member.entity.Role;
import com.sturdy.moneyallaround.domain.member.repository.MemberRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MemberService implements UserDetailsService {
    private final MemberRepository memberRepository;
    private final TokenProvider tokenProvider;
    private final RefreshTokenService refreshTokenService;
    private final FirebaseAuth firebaseAuth;

    @Transactional
    public FirebaseAuthResponse signIn(FirebaseAuthRequest request) {
//        try {
//            firebaseAuth.verifyIdToken(request.idToken());
//        } catch (FirebaseAuthException e) {
//            return new FirebaseAuthResponse();
//        }

        Optional<Member> member = memberRepository.findByTel(request.tel());
        if (member.isEmpty()) {
            return new FirebaseAuthResponse(false);
        }

        List<GrantedAuthority> roles = new ArrayList<>();
        roles.add(new SimpleGrantedAuthority(Role.ROLE_USER.toString()));

        Authentication authentication = new UsernamePasswordAuthenticationToken(request.tel(), null, roles);

        TokenInfo tokenInfo = tokenProvider.generateToken(authentication);

        member.get().setUid(request.uid());
        member.get().setDeviceToken(request.deviceToken());

        refreshTokenService.setValues(tokenInfo.getRefreshToken(), request.tel());

        return new FirebaseAuthResponse(true,
                FirebaseAuthResponse.SignInResponse.builder()
                        .id(member.get().getId())
                        .tel(member.get().getTel())
                        .nickname(member.get().getNickname())
                        .token(tokenInfo)
                        .build());
    }

    @Transactional
    public SignUpResponse signUp(SignUpRequest signUpRequest) {
        Member member = memberRepository.save(
                new Member(signUpRequest.tel(), signUpRequest.nickname(), signUpRequest.uid(), signUpRequest.imageUrl(), signUpRequest.deviceToken()));

        try {
            memberRepository.flush();
        } catch (DataIntegrityViolationException e) {
            throw new UserAuthException(ExceptionMessage.FAIL_SAVE_DATA);
        }

        List<GrantedAuthority> roles = new ArrayList<>();
        roles.add(new SimpleGrantedAuthority(Role.ROLE_USER.toString()));

        Authentication authentication = new UsernamePasswordAuthenticationToken(member.getTel(), null, roles);

        TokenInfo tokenInfo = tokenProvider.generateToken(authentication);

        refreshTokenService.setValues(tokenInfo.getRefreshToken(), member.getTel());

        return SignUpResponse.builder()
                .id(member.getId())
                .tel(member.getTel())
                .nickname(member.getNickname())
                .token(tokenInfo)
                .build();
    }

    @Transactional
    public void logout(LogoutRequest logoutRequest, String memberTel) {
        Member member = findByTel(memberTel);
        member.setUid(null);
        member.setDeviceToken(null);
        refreshTokenService.delValues(logoutRequest.refreshToken());
    }

    @Transactional
    public ReIssueResponse reissue(String refreshToken, Authentication authentication) {
        if (authentication.getName() == null) {
            throw new UserAuthException(ExceptionMessage.NOT_AUTHORIZED_ACCESS);
        }

        if (!tokenProvider.validateToken(refreshToken)) {
            Member member = findByTel(authentication.getName());
            member.setUid(null);
            member.setDeviceToken(null);
            refreshTokenService.delValues(refreshToken);
            throw new TokenNotFoundException(ExceptionMessage.TOKEN_VALID_TIME_EXPIRED);
        }

        String id = refreshTokenService.getValues(refreshToken);
        if (id == null || !id.equals(authentication.getName())) {
            throw new TokenCheckFailException(ExceptionMessage.MISMATCH_TOKEN);
        }

        return createAccessToken(refreshToken, authentication);
    }

    private ReIssueResponse createAccessToken(String refreshToken, Authentication authentication) {
        if (tokenProvider.checkExpiredToken(refreshToken)) {
            TokenInfo tokenInfo = tokenProvider.generateAccessToken(authentication);
            return ReIssueResponse.from(tokenInfo.getAccessToken(), "SUCCESS");
        }

        return ReIssueResponse.from(tokenProvider.generateAccessToken(authentication).getAccessToken(), "GENERAL_FAILURE");
    }

    @Transactional
    public UpdateProfileResponse updateProfile(UpdateProfileRequest request, String memberTel) {
        try {
            Member member = memberRepository.findByTel(memberTel).orElseThrow(IllegalArgumentException::new);
            member.update(request);
            return UpdateProfileResponse.from(member);
        } catch (DataIntegrityViolationException e) {
            throw new UserAuthException(ExceptionMessage.FAIL_UPDATE_DATA);
        }
    }

    @Transactional
    public void deleteMember(LogoutRequest request, String memberTel) {
        try {
            refreshTokenService.delValues(request.refreshToken());
            Member member = findByTel(memberTel);
            member.setUid(null);
            member.setDeviceToken(null);
            member.delete();
        } catch (DataIntegrityViolationException e) {
            throw new UserAuthException(ExceptionMessage.FAIL_DELETE_DATA);
        }
    }

    public CheckTelResponse checkTel(CheckTelnumberRequest request){
        String resultMessage = "SUCCESS";

        if(memberRepository.existsByTel(request.tel())){
            resultMessage = "FAIL";
        }

        return new CheckTelResponse(resultMessage);
    }

    public CheckNicknameResponse checkNickname(CheckNicknameRequest request){
        String resultMessage = "SUCCESS";

        if(memberRepository.existsByNickname(request.nickname())){
            resultMessage = "FAIL";
        }

        return new CheckNicknameResponse(resultMessage);
    }

    @Transactional
    public Member findByTel(String memberTel) {
        return memberRepository.findByTel(memberTel).orElseThrow(() -> new UserException(ExceptionMessage.USER_NOT_FOUND));
    }

    @Transactional
    public void updateRating(Long revieweeId, int reviewScore) {
        findById(revieweeId).updateRating(reviewScore);
    }

    @Transactional
    public void remittance(Long memberId, Integer amount) {
        findById(memberId).remittance(amount);
    }

    @Transactional
    public void deposit(Long memberId, Integer amount) {
        findById(memberId).deposit(amount);
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return memberRepository.findByTel(username)
                .orElseThrow(() -> new UsernameNotFoundException("해당 유저를 찾을 수 없습니다."));
    }

    public Member findById(Long id) {
        return memberRepository.findById(id)
                .orElseThrow(() -> new UserException(ExceptionMessage.USER_NOT_FOUND));
    }
}
