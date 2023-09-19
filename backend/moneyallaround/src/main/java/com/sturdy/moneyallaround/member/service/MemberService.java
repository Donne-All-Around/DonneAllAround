package com.sturdy.moneyallaround.member.service;

import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;
import com.sturdy.moneyallaround.Exception.model.UserAuthException;
import com.sturdy.moneyallaround.Exception.model.UserException;
import com.sturdy.moneyallaround.config.security.jwt.JwtTokenProvider;
import com.sturdy.moneyallaround.member.dto.request.CheckNicknameRequest;
import com.sturdy.moneyallaround.member.dto.request.CheckTelnumberRequest;
import com.sturdy.moneyallaround.member.dto.request.SignUpRequest;
import com.sturdy.moneyallaround.member.dto.response.CheckNicknameResponse;
import com.sturdy.moneyallaround.member.dto.response.CheckTelResponse;
import com.sturdy.moneyallaround.member.dto.response.ReIssueResponse;
import com.sturdy.moneyallaround.member.dto.response.SignUpResponse;
import com.sturdy.moneyallaround.member.entity.Member;
import com.sturdy.moneyallaround.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MemberService {
    private final MemberRepository memberRepository;
    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    private final JwtTokenProvider jwtTokenProvider;
    private final PasswordEncoder encoder;
    private final RefreshTokenService refreshTokenService;

    //registMember
    @Transactional
    public SignUpResponse registNewMember(SignUpRequest request){
        log.info(request.toString());
        Member member = memberRepository.save(Member.from(request, encoder));
        try {
            memberRepository.flush();
        }catch (DataIntegrityViolationException e){
            throw new UserAuthException(ExceptionMessage.FAIL_SAVE_DATA);
        }
        return SignUpResponse.from(member);
    }

    //로그인

    //멤버 업데이트

    //UpdateTelResponse

    // 멤버 삭제

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

    //인증번호 발송 (이거 파이어베이스?)
    //인증String 번호 제공 (이거 파이어베이스에서 하나?)

    @Transactional
    public Member findByMemberId(String memberId){
        Member member = memberRepository.findById(memberId).orElseThrow(
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

}
