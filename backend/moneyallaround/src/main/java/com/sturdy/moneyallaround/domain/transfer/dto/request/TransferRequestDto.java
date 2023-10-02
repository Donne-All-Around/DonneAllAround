package com.sturdy.moneyallaround.domain.transfer.dto.request;

import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.transfer.entity.Transfer;
import jakarta.validation.constraints.NotNull;

public record TransferRequestDto(@NotNull Integer amount,
                                 @NotNull Long tradeId) {
    public Transfer toTransfer(Trade trade) {
        return new Transfer(amount, trade);
    }
}
