package com.sturdy.moneyallaround.member.service;

import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;
import com.sturdy.moneyallaround.Exception.model.UserAuthException;
import com.sturdy.moneyallaround.Exception.model.UserException;
import com.sturdy.moneyallaround.config.security.jwt.JwtTokenProvider;
import com.sturdy.moneyallaround.member.dto.request.SignUpRequest;
import com.sturdy.moneyallaround.member.dto.response.SignUpResponse;
import com.sturdy.moneyallaround.member.entity.Member;
import com.sturdy.moneyallaround.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

    //회원가입

    //멤버 업데이트

    //UpdateTelResponse

    // 멤버 삭제
    //토큰 reIssue 권한


    //토큰 만료 검사

    //전화번호 체크

    //닉네임 체크

    //인증String 번호 제공

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
