package com.sturdy.moneyallaround.domain.trade.dto.response;

import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.entity.TradeStatus;
import com.sturdy.moneyallaround.domain.trade.entity.TradeType;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;

import java.time.LocalDateTime;

@Builder
public record TradeHistoryResponseDto(@NotNull Long id,
                                      @NotNull String title,
                                      @NotNull String description,
                                      @NotNull String thumbnailImageUrl,
                                      @NotNull TradeStatus status,
                                      @NotNull String countryCode,
                                      @NotNull Integer foreignCurrencyAmount,
                                      @NotNull Integer koreanWonAmount,
                                      @NotNull TradeType type,
                                      @NotNull String preferredTradeCountry,
                                      @NotNull String preferredTradeCity,
                                      @NotNull String preferredTradeDistrict,
                                      @NotNull String preferredTradeTown,
                                      @NotNull LocalDateTime createTime,
                                      @NotNull Boolean hasReview) {
    public static TradeHistoryResponseDto from(Trade trade, Boolean hasReview) {
        return TradeHistoryResponseDto.builder()
                .id(trade.getId())
                .title(trade.getTitle())
                .description(trade.getDescription())
                .thumbnailImageUrl(trade.getThumbnailImageUrl())
                .status(trade.getStatus())
                .countryCode(trade.getCountryCode())
                .foreignCurrencyAmount(trade.getForeignCurrencyAmount())
                .koreanWonAmount(trade.getKoreanWonAmount())
                .type(trade.getType())
                .preferredTradeCountry(trade.getPreferredTradeCountry())
                .preferredTradeCity(trade.getPreferredTradeCity())
                .preferredTradeDistrict(trade.getPreferredTradeDistrict())
                .preferredTradeTown(trade.getPreferredTradeTown())
                .createTime(trade.getCreateTime())
                .hasReview(hasReview)
                .build();
    }
}
