package com.sturdy.moneyallaround.domain.member.dto.request;

import jakarta.validation.constraints.NotNull;

public record LogInRequest(
        @NotNull String tel

) {
}
