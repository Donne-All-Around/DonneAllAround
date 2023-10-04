package com.sturdy.moneyallaround.domain.member.dto.request;

import com.sturdy.moneyallaround.domain.member.entity.Member;
import jakarta.validation.constraints.NotNull;

public record SignUpRequest(

        @NotNull String tel,
        @NotNull String nickname,
        String imageUrl,
        String uid


) {
}
