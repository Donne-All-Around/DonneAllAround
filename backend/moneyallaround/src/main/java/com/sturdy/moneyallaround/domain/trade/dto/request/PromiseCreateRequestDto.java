package com.sturdy.moneyallaround.domain.trade.dto.request;

import com.sturdy.moneyallaround.domain.trade.entity.TradeType;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;

public record PromiseCreateRequestDto(@NotNull Long buyerId,
                                      @NotNull TradeType type,
                                      LocalDateTime directTradeTime,
                                      String directTradeLocationDetail) {
}
