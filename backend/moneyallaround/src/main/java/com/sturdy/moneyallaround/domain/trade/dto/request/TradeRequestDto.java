package com.sturdy.moneyallaround.domain.trade.dto.request;

import com.sturdy.moneyallaround.domain.member.entity.Member;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.entity.TradeImage;
import jakarta.validation.constraints.NotNull;

import java.util.List;

public record TradeRequestDto(@NotNull String title,
                              @NotNull String description,
                              @NotNull String thumbnailImageUrl,
                              @NotNull String countryCode,
                              @NotNull Integer foreignCurrencyAmount,
                              @NotNull Integer koreanWonAmount,
                              @NotNull Double latitude,
                              @NotNull Double longitude,
                              @NotNull String preferredTradeCountry,
                              @NotNull String preferredTradeCity,
                              @NotNull String preferredTradeDistrict,
                              @NotNull String preferredTradeTown,
                              @NotNull List<String> imageUrlList) {
    public Trade toTrade(Member seller) {
        return Trade.builder()
                .title(title)
                .description(description)
                .thumbnailImageUrl(thumbnailImageUrl)
                .countryCode(countryCode)
                .foreignCurrencyAmount(foreignCurrencyAmount)
                .koreanWonAmount(koreanWonAmount)
                .latitude(latitude)
                .longitude(longitude)
                .preferredTradeCountry(preferredTradeCountry)
                .preferredTradeCity(preferredTradeCity)
                .preferredTradeDistrict(preferredTradeDistrict)
                .preferredTradeTown(preferredTradeTown)
                .seller(seller)
                .build();
    }
}
