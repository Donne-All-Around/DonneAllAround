package com.sturdy.moneyallaround.domain.member.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;

public record LogoutRequest(
        //refresh Token
        @Schema(description = "refresh token")
        String refreshToken
) {
}
