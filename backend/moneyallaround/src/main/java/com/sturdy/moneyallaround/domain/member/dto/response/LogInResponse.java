package com.sturdy.moneyallaround.domain.member.dto.response;

import com.sturdy.moneyallaround.config.security.jwt.TokenInfo;
import com.sturdy.moneyallaround.domain.member.entity.Member;

public record LogInResponse(
       TokenInfo token

) {

	// 기존 생성자에 멤버 정보를 받는 생성자 추가
	public LogInResponse(TokenInfo token) {
		this.token = token;
	}

	// 정적 메서드로 LogInResponse 객체 생성
	public static LogInResponse from(Member member, TokenInfo tokenInfo) {
		// 멤버 정보와 토큰 정보를 사용하여 LogInResponse 객체 생성 후 반환
		return new LogInResponse(tokenInfo);
	}


}
