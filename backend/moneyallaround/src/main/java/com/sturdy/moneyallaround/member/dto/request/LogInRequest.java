package com.sturdy.moneyallaround.member.dto.request;

import jakarta.validation.constraints.NotNull;

public record LogInRequest(
        @NotNull String tel
) {
}
