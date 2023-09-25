package com.sturdy.moneyallaround.member.dto.response;

import com.sturdy.moneyallaround.config.security.jwt.TokenInfo;

public record LogInResponse(
       TokenInfo token

) {
}
