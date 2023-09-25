package com.sturdy.moneyallaround.domain.keyword.dto.response;

import com.sturdy.moneyallaround.domain.keyword.entity.Keyword;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;

@Builder
public record KeywordResponseDto(@NotNull String countryCode,
                                 @NotNull String preferredTradeCountry,
                                 @NotNull String preferredTradeCity,
                                 @NotNull String preferredTradeDistrict,
                                 @NotNull String preferredTradeTown) {
    public static KeywordResponseDto from(Keyword keyword) {
        return KeywordResponseDto.builder()
                .countryCode(keyword.getCountryCode())
                .preferredTradeCountry(keyword.getPreferredTradeCountry())
                .preferredTradeCity(keyword.getPreferredTradeCity())
                .preferredTradeDistrict(keyword.getPreferredTradeDistrict())
                .preferredTradeTown(keyword.getPreferredTradeTown())
                .build();
    }
}
