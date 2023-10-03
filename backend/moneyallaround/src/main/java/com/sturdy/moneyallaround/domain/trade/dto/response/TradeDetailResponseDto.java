package com.sturdy.moneyallaround.domain.trade.dto.response;

import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.entity.TradeImage;
import com.sturdy.moneyallaround.domain.trade.entity.TradeStatus;
import com.sturdy.moneyallaround.domain.trade.entity.TradeType;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;

import java.time.LocalDateTime;
import java.util.List;

@Builder
public record TradeDetailResponseDto(@NotNull Long id,
                                     @NotNull String title,
                                     @NotNull String description,
                                     @NotNull TradeStatus status,
                                     @NotNull String countryCode,
                                     @NotNull Integer foreignCurrencyAmount,
                                     @NotNull Integer koreanWonAmount,
                                     @NotNull Double koreanWonPerForeignCurrency,
                                     @NotNull Double latitude,
                                     @NotNull Double longitude,
                                     String country,
                                     String administrativeArea,
                                     String subAdministrativeArea,
                                     String locality,
                                     String subLocality,
                                     String thoroughfare,
                                     @NotNull TradeType type,
                                     @NotNull List<String> imageUrlList,
                                     @NotNull Long sellerId,
                                     @NotNull String sellerNickname,
                                     @NotNull String sellerImageUrl,
                                     @NotNull Integer sellerRating,
                                     @NotNull Boolean isLike,
                                     @NotNull LocalDateTime createTime) {
    public static TradeDetailResponseDto from(Trade trade, Boolean isLike) {
        return TradeDetailResponseDto.builder()
                .id(trade.getId())
                .title(trade.getTitle())
                .description(trade.getDescription())
                .status(trade.getStatus())
                .countryCode(trade.getCountryCode())
                .foreignCurrencyAmount(trade.getForeignCurrencyAmount())
                .koreanWonAmount(trade.getKoreanWonAmount())
                .koreanWonPerForeignCurrency(trade.getKoreanWonPerForeignCurrency())
                .latitude(trade.getLatitude())
                .longitude(trade.getLongitude())
                .country(trade.getCountry())
                .administrativeArea(trade.getAdministrativeArea())
                .subAdministrativeArea(trade.getSubAdministrativeArea())
                .locality(trade.getLocality())
                .subLocality(trade.getSubLocality())
                .thoroughfare(trade.getThoroughfare())
                .type(trade.getType())
                .imageUrlList(trade.getImageList().stream().map(TradeImage::getUrl).toList())
                .sellerId(trade.getSeller().getId())
                .sellerNickname(trade.getSeller().getNickname())
                .sellerImageUrl(trade.getSeller().getImageUrl())
                .sellerRating(trade.getSeller().getRating())
                .isLike(isLike)
                .createTime(trade.getCreateTime())
                .build();
    }
}
