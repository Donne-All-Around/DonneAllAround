package com.sturdy.moneyallaround.domain.member.dto.response;

import com.sturdy.moneyallaround.config.security.jwt.TokenInfo;
import lombok.Builder;

public class FirebaseAuthResponse {
    boolean firebaseAuthStatus;
    boolean isMember;
    SignInResponse signInResponse;

    @Builder
    public static class SignInResponse {
        Long id;
        String tel;
        TokenInfo token;
    }

    // 파이어베이스 인증 오류
    public FirebaseAuthResponse() {
        firebaseAuthStatus = false;
        isMember = false;
    }

    // 파이어베이스 인증 성공 및 회원인 경우
    public FirebaseAuthResponse(boolean isMember, SignInResponse signInResponse) {
        firebaseAuthStatus = true;
        this.isMember = isMember;
        this.signInResponse = signInResponse;
    }

    // 파이어베이스 인증 성공 및 회원이 아닌 경우
    public FirebaseAuthResponse(boolean isMember) {
        firebaseAuthStatus = true;
        this.isMember = isMember;
    }
}