package com.sturdy.moneyallaround.domain.member.dto.response;

import com.sturdy.moneyallaround.config.security.jwt.TokenInfo;
import lombok.Builder;

@Builder
public record SignUpResponse(
        Long id,
        String tel,
        TokenInfo token) {
}
