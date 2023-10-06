package com.sturdy.moneyallaround.domain.keyword.dto.request;

import com.sturdy.moneyallaround.domain.keyword.entity.Keyword;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import jakarta.validation.constraints.NotNull;

public record KeywordRequestDto(@NotNull String countryCode,
                                String country,
                                String administrativeArea,
                                String subAdministrativeArea,
                                String locality,
                                String subLocality,
                                String thoroughfare) {
    public Keyword toKeyword(Member member) {
        return Keyword.builder()
                .countryCode(countryCode)
                .country(country)
                .administrativeArea(administrativeArea)
                .subAdministrativeArea(subAdministrativeArea)
                .locality(locality)
                .subLocality(subLocality)
                .thoroughfare(thoroughfare)
                .member(member)
                .build();
    }
}
