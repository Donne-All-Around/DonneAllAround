package com.sturdy.moneyallaround.domain.trade.dto.response;

import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.entity.TradeStatus;
import com.sturdy.moneyallaround.domain.trade.entity.TradeType;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;

import java.time.LocalDateTime;

@Builder
public record TradeChatResponseDto(@NotNull Long id,
                                   @NotNull Long sellerId,
                                   @NotNull String thumbnailImage,
                                   @NotNull String title,
                                   @NotNull String countryCode,
                                   @NotNull Integer foreignCurrencyAmount,
                                   @NotNull Integer koreanWonAmount,
                                   @NotNull TradeStatus status,
                                   @NotNull TradeType type,
                                   @NotNull Boolean hasReview,
                                   @NotNull Boolean hasTransfer,
                                   Long buyerId,
                                   @NotNull LocalDateTime createTime) {
    public static TradeChatResponseDto from(Trade trade, Boolean hasReview, Boolean hasTransfer) {
        return TradeChatResponseDto.builder()
                .id(trade.getId())
                .sellerId(trade.getSeller().getId())
                .thumbnailImage(trade.getThumbnailImageUrl())
                .title(trade.getTitle())
                .countryCode(trade.getCountryCode())
                .foreignCurrencyAmount(trade.getForeignCurrencyAmount())
                .koreanWonAmount(trade.getKoreanWonAmount())
                .status(trade.getStatus())
                .type(trade.getType())
                .hasReview(hasReview)
                .hasTransfer(hasTransfer)
                .buyerId(trade.getBuyer() == null ? null : trade.getBuyer().getId())
                .createTime(trade.getCreateTime())
                .build();
    }
}
