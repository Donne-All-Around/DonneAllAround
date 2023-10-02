package com.sturdy.moneyallaround.domain.member.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

public record TokenResponse(
		@Schema(description = "토큰 권한 부여 유형",example = "Bearer")
		String grantType,

		@Schema(description = "accessToken",example = "")
		String accessToken
) {

	public static TokenResponse from(String accessToken){
		return new TokenResponse(
				"Bearer",
				accessToken
		);
	}
}
