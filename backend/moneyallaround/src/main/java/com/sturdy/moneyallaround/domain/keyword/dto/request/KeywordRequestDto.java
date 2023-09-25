package com.sturdy.moneyallaround.domain.keyword.dto.request;

import com.sturdy.moneyallaround.domain.keyword.entity.Keyword;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import jakarta.validation.constraints.NotNull;

public record KeywordRequestDto(@NotNull String countryCode,
                                @NotNull String preferredTradeCountry,
                                @NotNull String preferredTradeCity,
                                @NotNull String preferredTradeDistrict,
                                @NotNull String preferredTradeTown) {
    public Keyword toKeyword(Member member) {
        return Keyword.builder()
                .countryCode(countryCode)
                .preferredTradeCountry(preferredTradeCountry)
                .preferredTradeCity(preferredTradeCity)
                .preferredTradeDistrict(preferredTradeDistrict)
                .preferredTradeTown(preferredTradeTown)
                .member(member)
                .build();
    }
}
