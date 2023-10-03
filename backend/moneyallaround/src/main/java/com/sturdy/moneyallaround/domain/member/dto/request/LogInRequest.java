package com.sturdy.moneyallaround.domain.member.dto.request;

import jakarta.validation.constraints.NotNull;

public record LogInRequest(
        @NotNull String tel

) {
	private static String firebaseToken;

	public String getFirebaseToken() {
		return firebaseToken;
	}

	public String getTel() {
		return tel;
	}
}
