package com.sturdy.moneyallaround.domain.member.service;

import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;
import com.sturdy.moneyallaround.Exception.model.UserAuthException;
import com.sturdy.moneyallaround.Exception.model.UserException;
//import com.sturdy.moneyallaround.config.security.jwt.JwtTokenProvider;
import com.sturdy.moneyallaround.domain.member.dto.request.CheckNicknameRequest;
import com.sturdy.moneyallaround.domain.member.dto.request.CheckTelnumberRequest;
import com.sturdy.moneyallaround.domain.member.dto.request.SignUpRequest;
import com.sturdy.moneyallaround.domain.member.dto.request.UpdateProfileRequest;
import com.sturdy.moneyallaround.domain.member.dto.response.*;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import com.sturdy.moneyallaround.domain.member.repository.MemberRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
//import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
//import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MemberService {
    private final MemberRepository memberRepository;
    //private final AuthenticationManagerBuilder authenticationManagerBuilder;
  //  private final JwtTokenProvider jwtTokenProvider;
  //  private final PasswordEncoder encoder;
    private final RefreshTokenService refreshTokenService;

    public

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
    public UpdateProfileResponse updateProfile(UpdateProfileRequest request, Long memberId) {
        try {
            Member member = memberRepository.findById(memberId).orElseThrow(IllegalArgumentException::new);
            member.update(request);
            return UpdateProfileResponse.from(member);
        } catch (DataIntegrityViolationException e) {
            throw new UserAuthException(ExceptionMessage.FAIL_UPDATE_DATA);
        }
    }



    //UpdateTelResponse



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
}
