package com.sturdy.moneyallaround.domain.trade.dto.request;

import jakarta.validation.constraints.NotNull;

public record AccountNumberRequestDto(@NotNull String sellerAccountBankCode,
                                      @NotNull String sellerAccountNumber) {
}
