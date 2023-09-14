package com.sturdy.moneyallaround.domain.trade.dto.response;

import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import jakarta.validation.constraints.NotNull;

public record TradeCreateResponseDto(@NotNull Long tradeId) {
    public static TradeCreateResponseDto from(Trade trade) {
        return new TradeCreateResponseDto(trade.getId());
    }
}
