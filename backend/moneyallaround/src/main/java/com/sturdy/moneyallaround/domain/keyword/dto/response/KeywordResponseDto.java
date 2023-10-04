package com.sturdy.moneyallaround.domain.keyword.dto.response;

import com.sturdy.moneyallaround.domain.keyword.entity.Keyword;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;

@Builder
public record KeywordResponseDto(@NotNull Long id,
                                 @NotNull String countryCode,
                                 String country,
                                 String administrativeArea,
                                 String subAdministrativeArea,
                                 String locality,
                                 String subLocality,
                                 String thoroughfare) {
    public static KeywordResponseDto from(Keyword keyword) {
        return KeywordResponseDto.builder()
                .id(keyword.getId())
                .countryCode(keyword.getCountryCode())
                .country(keyword.getCountry())
                .administrativeArea(keyword.getAdministrativeArea())
                .subAdministrativeArea(keyword.getSubAdministrativeArea())
                .locality(keyword.getLocality())
                .subLocality(keyword.getSubLocality())
                .thoroughfare(keyword.getThoroughfare())
                .build();
    }
}
