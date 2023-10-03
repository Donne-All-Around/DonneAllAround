package com.sturdy.moneyallaround.domain.member.service;

import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;
import com.sturdy.moneyallaround.Exception.model.*;
import com.sturdy.moneyallaround.config.security.jwt.JwtTokenProvider;
import com.sturdy.moneyallaround.config.security.jwt.TokenInfo;
import com.sturdy.moneyallaround.domain.member.dto.request.*;
import com.sturdy.moneyallaround.domain.member.dto.response.*;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import com.sturdy.moneyallaround.domain.member.repository.MemberRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MemberService implements UserDetailsService {
    private final MemberRepository memberRepository;
    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    private final JwtTokenProvider jwtTokenProvider;
    private final RefreshTokenService refreshTokenService;


    //registMember
    @Transactional
    public LogInResponse registNewMember(SignUpRequest request){
        log.info(request.toString());
        Member member = memberRepository.save(Member.from(request));

        // Firebase 토큰 검증
        String firebaseToken = request.getFirebaseToken();
        if (!verifyFirebaseToken(firebaseToken)) {
            throw new FirebaseTokenValidationException("Firebase 토큰 검증 실패");
        }

        // 사용자 정보로 JWT 토큰을 생성하여 자동으로 로그인
        TokenInfo tokenInfo = jwtTokenProvider.generateToken(member.getTel(), firebaseToken, null);

        // 로그인 응답을 생성하여 반환
        LogInResponse loginResponse = LogInResponse.from(member, tokenInfo);

        return loginResponse;
    }


    public boolean verifyFirebaseToken(String firebaseToken) {
        return jwtTokenProvider.isValidFirebaseToken(firebaseToken);
    }


    // 로그인 로직
    public LogInResponse logIn(LogInRequest request) {
        String firebaseToken = request.getFirebaseToken();

        // Firebase 토큰을 검증하고, 유효한 사용자인지 확인한다.
        if (!verifyFirebaseToken(firebaseToken)) {
            throw new FirebaseTokenValidationException("Firebase 토큰 검증 실패");
        }

        // Firebase 토큰이 유효하면, 해당 사용자를 데이터베이스에서 찾아온다.
        Member member = memberRepository.findByTel(request.getTel())
                .orElseThrow(() -> new UserException(ExceptionMessage.USER_NOT_FOUND));

        // 사용자 정보로 JWT 토큰을 생성한다.
        TokenInfo tokenInfo = jwtTokenProvider.generateToken(request.getTel(), firebaseToken, null);

        // 로그인 응답을 생성하여 반환한다.
        return LogInResponse.from(member, tokenInfo);
    }

    //멤버 업데이트
    @Transactional
    public UpdateProfileResponse updateProfile(UpdateProfileRequest request, Long memberId) {
        try {
            Member member = memberRepository.findById(memberId).orElseThrow(IllegalArgumentException::new);
            member.update(request);
            return UpdateProfileResponse.from(member);
        } catch (DataIntegrityViolationException e) {
            throw new UserAuthException(ExceptionMessage.FAIL_UPDATE_DATA);
        }
    }


    // 멤버 삭제
    public String deleteMember(String memberId) {
        try {
            memberRepository.deleteById(memberId);
        } catch (DataIntegrityViolationException e) {
            throw new UserAuthException(ExceptionMessage.FAIL_DELETE_DATA);
        }

        return "SUCCESS";
    }

    @Transactional
    public ReIssueResponse getAuthorize(String accessToken){
        return ReIssueResponse.from(accessToken, "GET_AUTHORIZE");
    }



    @Transactional
    public ReIssueResponse reissue(String refreshToken, Authentication authentication) {
        // 1. 인가 이름 확인
        log.info("authentication.getName={}", authentication.getName());
        if (authentication.getName() == null) {
            throw new UserAuthException(ExceptionMessage.NOT_AUTHORIZED_ACCESS);
        }
        log.info("refreshToken={}", refreshToken);
        // 2. refreshToken 만료 검사
        if(!jwtTokenProvider.validateToken(refreshToken)){
            // 2-1. refreshToken 만료 시, Redis에서 삭제
            // Front에서 Logout 실행
            refreshTokenService.delValues(refreshToken);
            throw new TokenNotFoundException(ExceptionMessage.TOKEN_VALID_TIME_EXPIRED);

        }
        // 3. Redis에서 refreshToken 가져오기
        String id = refreshTokenService.getValues(refreshToken);
        log.info("id from redis={}", id);
        // 4. 권한 검사
        if(id == null || !id.equals(authentication.getName())){
            throw new TokenCheckFailException(ExceptionMessage.MISMATCH_TOKEN);
        }
        return createAccessToken(refreshToken, authentication);
    }


    /**
     * RefreshToken으로 AccessToken 재발급
     */

    private ReIssueResponse createAccessToken(String refreshToken, Authentication authentication) {
        // 5. RefreshToken의 만료 기간 확인
        if (jwtTokenProvider.expiredToken(refreshToken)){
            TokenInfo tokenInfo = jwtTokenProvider.generateAccessToken(authentication);
            // 6. RefreshToken으로 AccessToke 발급 성공
            return ReIssueResponse.from(tokenInfo.getAccessToken(), "SUCCESS");
        }
        // RefreshToken 발급 실패
        return ReIssueResponse.from(jwtTokenProvider.generateAccessToken(authentication).getAccessToken(),"GENERAL_FAILURE");

    }

    //전화번호 체크
    @Transactional
    public CheckTelResponse checkTel(CheckTelnumberRequest request){
        String resultMessage = "SUCCESS";
        log.info(request.tel());
        Optional<Member> member = memberRepository.findByTel(request.tel());
        if(member.isPresent()){
            resultMessage = "FAIL";
        }
        log.info("resultMessage = {}", resultMessage);
        return new CheckTelResponse(resultMessage);
    }

    //닉네임 체크
    @Transactional
    //request 객체 입력 받고 response 반환
    public CheckNicknameResponse checkNickname(CheckNicknameRequest request){
        String resultMessage = "SUCCESS";   //초기값 success , 최종반환 응답 메시지
        log.info(request.nickname());
        Optional<Member> member = memberRepository.findByNickname(request.nickname());
        if(member.isPresent()){
            resultMessage = "FAIL";
        } //동일 닉네임 있으면 fail 반환
        log.info("resultMessage = {}", resultMessage);
        return new CheckNicknameResponse(resultMessage); //중복 여부 반환
    }


    @Transactional
    public Member findById(Long id){
        Member member = memberRepository.findById(id).orElseThrow(
                () -> new UserException(ExceptionMessage.USER_NOT_FOUND)
        );
        return member;
    }


    @Transactional
    public Member findByNickname(String nickname) {
        Member member = memberRepository.findByNickname(nickname).orElseThrow(
                () -> new UserException(ExceptionMessage.USER_NOT_FOUND)
        );
        return member;
    }

    @Transactional
    public Member findByTel(String tel) {
        Member member = memberRepository.findByTel(tel).orElseThrow(
                () -> new UserException(ExceptionMessage.USER_NOT_FOUND)
        );
        return member;
    }

    @Transactional
    public void updateRating(Long revieweeId, int reviewScore) {
        findById(revieweeId).updateRating(reviewScore);
    }


    //UserDetailService
    //우리가 지금 유저 이름이 없어서 Tel 넣었어
    @Override
    public UserDetails loadUserByUsername(String tel) throws UsernameNotFoundException {
        System.out.println("유저 찾기");
        return memberRepository.findByTel(tel)
                .orElseThrow(() -> new UsernameNotFoundException("해당하는 유저를 찾을 수 없습니다."));
    }


}
