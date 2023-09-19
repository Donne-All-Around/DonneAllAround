package com.sturdy.moneyallaround.domain.trade.dto.response;

import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.entity.TradeStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;

import java.time.LocalDateTime;

@Builder
public record TradeSimpleResponseDto(@NotNull Long id,
                                     @NotNull String title,
                                     @NotNull String thumbnailImageUrl,
                                     @NotNull TradeStatus status,
                                     @NotNull String countryCode,
                                     @NotNull Integer foreignCurrencyAmount,
                                     @NotNull Integer koreanWonAmount,
                                     @NotNull Double koreanWonPerForeignCurrency,
                                     @NotNull String preferredTradeCountry,
                                     @NotNull String preferredTradeCity,
                                     @NotNull String preferredTradeDistrict,
                                     @NotNull String preferredTradeTown,
                                     @NotNull Integer tradeLikeCount,
                                     @NotNull LocalDateTime createTime) {
    public static TradeSimpleResponseDto from(Trade trade) {
        return TradeSimpleResponseDto.builder()
                .id(trade.getId())
                .title(trade.getTitle())
                .thumbnailImageUrl(trade.getThumbnailImageUrl())
                .status(trade.getStatus())
                .countryCode(trade.getCountryCode())
                .foreignCurrencyAmount(trade.getForeignCurrencyAmount())
                .koreanWonAmount(trade.getKoreanWonAmount())
                .koreanWonPerForeignCurrency(trade.getKoreanWonPerForeignCurrency())
                .preferredTradeCountry(trade.getPreferredTradeCountry())
                .preferredTradeCity(trade.getPreferredTradeCity())
                .preferredTradeDistrict(trade.getPreferredTradeDistrict())
                .preferredTradeTown(trade.getPreferredTradeTown())
                .tradeLikeCount(trade.getLikeList().size())
                .createTime(trade.getCreateTime())
                .build();
    }
}
