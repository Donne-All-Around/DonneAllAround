package com.sturdy.moneyallaround.domain.member.dto.response;

import com.sturdy.moneyallaround.config.security.jwt.TokenInfo;
import lombok.Builder;
import lombok.Getter;

@Builder
public record SignUpResponse(
        Long id,
        String tel,
        TokenInfo token) {
}
