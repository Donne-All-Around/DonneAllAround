package com.sturdy.moneyallaround.member.dto.request;

import jakarta.validation.constraints.NotNull;

public record SignUpRequest(

        @NotNull String tel,
        @NotNull String nickname,
        String imageUrl


) {
}
