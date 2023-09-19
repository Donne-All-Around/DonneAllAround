package com.sturdy.moneyallaround.domain.trade.dto.response;

import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.entity.TradeImage;
import com.sturdy.moneyallaround.domain.trade.entity.TradeStatus;
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
                                     @NotNull String preferredTradeCountry,
                                     @NotNull String preferredTradeCity,
                                     @NotNull String preferredTradeDistrict,
                                     @NotNull String preferredTradeTown,
                                     @NotNull List<String> imageUrlList,
                                     @NotNull Long sellerId,
                                     @NotNull String sellerNickname,
                                     @NotNull String sellerImageUrl,
                                     @NotNull Integer sellerPoint,
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
                .preferredTradeCountry(trade.getPreferredTradeCountry())
                .preferredTradeCity(trade.getPreferredTradeCity())
                .preferredTradeDistrict(trade.getPreferredTradeDistrict())
                .preferredTradeTown(trade.getPreferredTradeTown())
                .imageUrlList(trade.getImageList().stream().map(TradeImage::getUrl).toList())
                .sellerId(trade.getSeller().getId())
                .sellerNickname(trade.getSeller().getNickname())
                .sellerImageUrl(trade.getSeller().getImageUrl())
                .sellerPoint(trade.getSeller().getPoint())
                .isLike(isLike)
                .createTime(trade.getCreateTime())
                .build();
    }
}
