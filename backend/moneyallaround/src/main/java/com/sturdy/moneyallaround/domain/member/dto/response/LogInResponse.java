package com.sturdy.moneyallaround.domain.member.dto.response;

//import com.sturdy.moneyallaround.config.security.jwt.TokenInfo;

import com.sturdy.moneyallaround.config.security.jwt.TokenInfo;

public record LogInResponse(
        Long id,
        String nickname,
        String tel,
        TokenInfo tokenInfo
) {
}
