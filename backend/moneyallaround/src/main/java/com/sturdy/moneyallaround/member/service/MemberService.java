package com.sturdy.moneyallaround.member.service;

import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;
import com.sturdy.moneyallaround.Exception.model.SmsAuthenticationException;
import com.sturdy.moneyallaround.config.security.jwt.JwtTokenProvider;
import com.sturdy.moneyallaround.member.dto.request.SignUpRequest;
import com.sturdy.moneyallaround.member.dto.response.SignUpResponse;
import com.sturdy.moneyallaround.member.entity.Member;
import com.sturdy.moneyallaround.member.repository.MemberRepository;
import jakarta.persistence.EntityNotFoundException;
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


    @Transactional
    public Member findByMemberId(String memberId){
        Member member = memberRepository.findById(memberId).orElseThrow(
                () -> new SmsAuthenticationException(ExceptionMessage.SMS_NOT_FOUND)
        );

        return member;
    }

}
