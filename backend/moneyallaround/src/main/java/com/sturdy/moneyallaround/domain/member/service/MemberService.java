package com.sturdy.moneyallaround.domain.member.service;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;
import com.sturdy.moneyallaround.Exception.model.TokenCheckFailException;
import com.sturdy.moneyallaround.Exception.model.TokenNotFoundException;
import com.sturdy.moneyallaround.Exception.model.UserAuthException;
import com.sturdy.moneyallaround.Exception.model.UserException;
//import com.sturdy.moneyallaround.config.security.jwt.JwtTokenProvider;
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
//import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
//import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MemberService implements UserDetailsService {
    private final MemberRepository memberRepository;
    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    private final TokenProvider tokenProvider;
  //  private final PasswordEncoder encoder;
    private final RefreshTokenService refreshTokenService;
    private final FirebaseAuth firebaseAuth;

    @Transactional
    public FirebaseAuthResponse signIn(FirebaseAuthRequest request) {
        log.info("memberservice - signin");
        log.info("request = {}", request);

        try {
            FirebaseToken firebaseToken = firebaseAuth.verifyIdToken(request.idToken());
            log.info("{}", firebaseToken);
        } catch (FirebaseAuthException e) {
            return new FirebaseAuthResponse();
        }

        log.info("파이어베이스 인증 완료");

        Optional<Member> member = memberRepository.findByTel(request.tel());
        if (member.isEmpty()) {
            return new FirebaseAuthResponse(false);
        }

        log.info("사용자 찾음");

        List<GrantedAuthority> roles = new ArrayList<>();
        roles.add(new SimpleGrantedAuthority(Role.ROLE_USER.toString()));

        Authentication authentication = new UsernamePasswordAuthenticationToken(request.tel(), null, roles);

        TokenInfo tokenInfo = tokenProvider.generateToken(authentication);

        member.get().setUid(request.uid());

        // 토큰 저장
        refreshTokenService.setValues(tokenInfo.getRefreshToken(), request.tel());

        return new FirebaseAuthResponse(true,
                FirebaseAuthResponse.SignInResponse.builder()
                        .id(member.get().getId())
                        .tel(member.get().getTel())
                        .token(tokenInfo)
                        .build());
    }

    @Transactional
    public SignUpResponse signUp(SignUpRequest signUpRequest) {
        Member member = memberRepository.save(
                new Member(signUpRequest.tel(), signUpRequest.nickname(), signUpRequest.uid(), signUpRequest.imageUrl()));

        try {
            memberRepository.flush();
        } catch (DataIntegrityViolationException e) {
            throw new UserAuthException(ExceptionMessage.FAIL_SAVE_DATA);
        }

        log.info("member 저장");

        List<GrantedAuthority> roles = new ArrayList<>();
        roles.add(new SimpleGrantedAuthority(Role.ROLE_USER.toString()));

        Authentication authentication = new UsernamePasswordAuthenticationToken(member.getTel(), null, roles);

        TokenInfo tokenInfo = tokenProvider.generateToken(authentication);

        log.info("accessToken: {}", tokenInfo.getAccessToken());
        log.info("refreshToken: {}", tokenInfo.getRefreshToken());
        log.info("tel: {}", member.getTel());

        // 토큰 저장
        refreshTokenService.setValues(tokenInfo.getRefreshToken(), member.getTel());

        return SignUpResponse.builder()
                .id(member.getId())
                .tel(member.getTel())
                .token(tokenInfo)
                .build();
    }

    public void logout(LogoutRequest logoutRequest, String memberTel) {
        findByTel(memberTel).setUid(null);
        refreshTokenService.delValues(logoutRequest.refreshToken());
    }

    public ReIssueResponse reissue(String refreshToken, Authentication authentication) {
        if (authentication.getName() == null) {
            throw new UserAuthException(ExceptionMessage.NOT_AUTHORIZED_ACCESS);
        }

        if (!tokenProvider.validateToken(refreshToken)) {
            findByTel(authentication.getName()).setUid(null);
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

    //registMember
//    @Transactional
//    public SignUpResponse registNewMember(SignUpRequest request){
//        log.info(request.toString());
//        Member member = memberRepository.save(Member.from(request, encoder));
//        try {
//            memberRepository.flush();
//        }catch (DataIntegrityViolationException e){
//            throw new UserAuthException(ExceptionMessage.FAIL_SAVE_DATA);
//        }
//        return SignUpResponse.from(member);
//    }

    //로그인
//    @Transactional
//    public LogInResponse logIn(LogInRequest request) {
//
//        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken();
//        log.info("authenticationToken = {}", authenticationToken);
//    }

//    @Transactional
//    public LogInResponse signIn(LogInRequest request) {
//
//        // 1. Login ID/PW 를 기반으로 Authentication 객체 생성
//        // 이때 authentication 는 인증 여부를 확인하는 authenticated 값이 false
//        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(request.id(), request.password());
//        log.info("authenticationToken={}", authenticationToken);
//
//        log.info("Email Login");
//        // 2. 실제 검증 (사용자 비밀번호 체크)이 이루어지는 부분
//        // authenticate 매서드가 실행될 때 CustomUserDetailsService 에서 만든 loadUserByUsername 메서드가 실행
//        Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);
//        log.info("authentication={}", authentication);
//
//        // 2-1. 비밀번호 체크
//        Optional<Member> member = memberRepository.findById(request.id());
//        log.info("member={}", member.get().getId());
//        if(member.isEmpty()){
//            throw new UserAuthException(ExceptionMessage.USER_NOT_FOUND);
//        } else if(!encoder.matches(request.password(), member.get().getPassword())) {
//            throw new UserAuthException(ExceptionMessage.MISMATCH_PASSWORD);
//        }
//        // 3. 인증 정보를 기반으로 JWT 토큰 생성
//        TokenInfo tokenInfo = jwtTokenProvider.generateToken(authentication);
//
//        String nickname = member.get().getNickname();
//        String image = member.get().getImage();
//
//        return new SignInResponse(request.id(), nickname,image, tokenInfo);
//    }


    //멤버 업데이트
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



    //UpdateTelResponse



    @Transactional
    public String deleteMember(LogoutRequest request, String memberTel) {
        try {
            refreshTokenService.delValues(request.refreshToken());
            Member member = findByTel(memberTel);
            member.setUid(null);
            member.delete();
        } catch (DataIntegrityViolationException e) {
            throw new UserAuthException(ExceptionMessage.FAIL_DELETE_DATA);
        }

        return "SUCCESS";
    }

    @Transactional
    public ReIssueResponse getAuthorize(String accessToken){
        return ReIssueResponse.from(accessToken, "GET_AUTHORIZE");
    }



    //토큰 만료 검사 및 reissue 해주기
//    @Transactional
//    public ReIssueResponse reissue(String refreshToken, Authentication authentication) {
//
//    }

    //refresh token 만료 검사 및 redis에서 가져오기, 권한 검사)

    /**
     * RefreshToken으로 AccessToken 재발급
     */

    //토큰 만료 검사 (기간 확인 및 access token 재발급)

    //전화번호 체크
    public CheckTelResponse checkTel(CheckTelnumberRequest request){
        String resultMessage = "SUCCESS";
        log.info(request.tel());

        if(memberRepository.existsByTel(request.tel())){
            resultMessage = "FAIL";
        }
        log.info("resultMessage = {}", resultMessage);
        return new CheckTelResponse(resultMessage);
    }

    //닉네임 체크
    //request 객체 입력 받고 response 반환
    public CheckNicknameResponse checkNickname(CheckNicknameRequest request){
        String resultMessage = "SUCCESS";   //초기값 success , 최종반환 응답 메시지
        log.info(request.nickname());

        if(memberRepository.existsByNickname(request.nickname())){
            resultMessage = "FAIL";
        } //동일 닉네임 있으면 fail 반환
        log.info("resultMessage = {}", resultMessage);
        return new CheckNicknameResponse(resultMessage); //중복 여부 반환
    }

    //인증번호 발송 (이거 파이어베이스?)
    //인증String 번호 제공 (이거 파이어베이스에서 하나?)

    @Transactional
    public Member findById(Long id){
        Member member = memberRepository.findById(id).orElseThrow(
                () -> new UserException(ExceptionMessage.USER_NOT_FOUND)
        );
        return member;
    }

    @Transactional
    public Member findByTel(String memberTel) {
        return memberRepository.findByTel(memberTel).orElseThrow(() -> new UserException(ExceptionMessage.USER_NOT_FOUND));
    }

    @Transactional
    public Member findBuNickname(String nickname) {
        Member member = memberRepository.findByNickname(nickname).orElseThrow(
                () -> new UserException(ExceptionMessage.USER_NOT_FOUND)
        );
        return member;
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
}
