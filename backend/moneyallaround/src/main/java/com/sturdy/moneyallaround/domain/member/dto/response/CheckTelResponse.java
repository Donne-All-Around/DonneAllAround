package com.sturdy.moneyallaround.domain.member.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

public record CheckTelResponse(
        @Schema(description = "전화번호 중복 여부")
        String resultMessage
) {
}
