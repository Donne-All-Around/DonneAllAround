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
                                      String country,
                                      String administrativeArea,
                                      String subAdministrativeArea,
                                      String locality,
                                      String subLocality,
                                      String thoroughfare,
                                      @NotNull Boolean hasReview,
                                      @NotNull LocalDateTime createTime) {
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
                .country(trade.getCountry())
                .administrativeArea(trade.getAdministrativeArea())
                .subAdministrativeArea(trade.getSubAdministrativeArea())
                .locality(trade.getLocality())
                .subLocality(trade.getSubLocality())
                .thoroughfare(trade.getThoroughfare())
                .hasReview(hasReview)
                .createTime(trade.getCreateTime())
                .build();
    }
}
