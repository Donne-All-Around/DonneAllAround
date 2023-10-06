package com.sturdy.moneyallaround.domain.trade.dto.request;

import jakarta.validation.constraints.NotNull;

public record PromiseRequestDto(@NotNull Long buyerId) {
}
