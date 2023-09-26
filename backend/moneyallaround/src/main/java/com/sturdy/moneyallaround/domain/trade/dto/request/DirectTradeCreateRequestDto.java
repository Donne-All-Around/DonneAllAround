package com.sturdy.moneyallaround.domain.trade.dto.request;

import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public record DirectTradeCreateRequestDto(@NotNull Long buyerId,
                                          String directTradeTime,
                                          String directTradeLocationDetail) {
    public LocalDateTime getDirectTradeTime() {
        return LocalDateTime.parse(directTradeTime, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }
}
