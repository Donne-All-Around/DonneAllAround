package com.sturdy.moneyallaround.domain.member.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;

public record TokenRequest(
		@Schema(description = "FIREBASE TOKEN")
		String firebaseToken

) {
}
