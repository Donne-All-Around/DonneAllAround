package com.sturdy.moneyallaround.domain.trade.dto.request;

import jakarta.validation.constraints.NotNull;

public record SellerAccountNumberRequestDto(@NotNull String sellerAccountNumber) {
}
