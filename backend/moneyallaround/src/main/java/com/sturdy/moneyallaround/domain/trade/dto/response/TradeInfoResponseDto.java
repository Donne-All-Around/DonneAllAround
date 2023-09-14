package com.sturdy.moneyallaround.domain.trade.dto.response;

import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.entity.TradeStatus;
import jakarta.validation.constraints.NotNull;

public record TradeInfoResponseDto(@NotNull String title,
                                   @NotNull String description,
                                   @NotNull TradeStatus status,
                                   @NotNull String countryCode,
                                   @NotNull Integer foreignCurrencyAmount,
                                   @NotNull Integer koreanWonAmount,
                                   @NotNull Double latitude,
                                   @NotNull Double longitude,
                                   @NotNull String preferredTradeCountry,
                                   @NotNull String preferredTradeCity,
                                   @NotNull String preferredTradeDistrict,
                                   @NotNull String preferredTradeTown,
                                   @NotNull Long sellerId,
                                   @NotNull String sellerNickname,
                                   @NotNull String sellerProfileImageUrl) {
    public static TradeInfoResponseDto from(Trade trade) {
        return new TradeInfoResponseDto(
                trade.getTitle(),
                trade.getDescription(),
                trade.getStatus(),
                trade.getCountryCode(),
                trade.getForeignCurrencyAmount(),
                trade.getKoreanWonAmount(),
                trade.getLatitude(),
                trade.getLongitude(),
                trade.getPreferredTradeCountry(),
                trade.getPreferredTradeCity(),
                trade.getPreferredTradeDistrict(),
                trade.getPreferredTradeTown(),
                trade.getSeller().getId(),
                trade.getSeller().getNickname(),
                trade.getSeller().getProfileImageUrl()
        );
    }
}
