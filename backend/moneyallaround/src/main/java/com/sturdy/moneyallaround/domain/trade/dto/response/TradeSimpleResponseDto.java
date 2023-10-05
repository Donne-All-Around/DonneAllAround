package com.sturdy.moneyallaround.domain.trade.dto.response;

import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.entity.TradeStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;

import java.time.LocalDateTime;

@Builder
public record TradeSimpleResponseDto(Long id,
                                     String title,
                                     String thumbnailImageUrl,
                                     TradeStatus status,
                                     String countryCode,
                                     Integer foreignCurrencyAmount,
                                     Integer koreanWonAmount,
                                     Double koreanWonPerForeignCurrency,
                                     String country,
                                     String administrativeArea,
                                     String subAdministrativeArea,
                                     String locality,
                                     String subLocality,
                                     String thoroughfare,
                                     Integer tradeLikeCount,
                                     LocalDateTime createTime) {
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
                .country(trade.getCountry())
                .administrativeArea(trade.getAdministrativeArea())
                .subAdministrativeArea(trade.getSubAdministrativeArea())
                .locality(trade.getLocality())
                .subLocality(trade.getSubLocality())
                .thoroughfare(trade.getThoroughfare())
                .tradeLikeCount(trade.getLikeList().size())
                .createTime(trade.getCreateTime())
                .build();
    }
}
