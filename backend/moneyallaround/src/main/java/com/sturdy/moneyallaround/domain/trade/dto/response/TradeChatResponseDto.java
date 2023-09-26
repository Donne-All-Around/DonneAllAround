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
                                   Long buyerId,
                                   LocalDateTime directTradeTime,
                                   String directTradeLocationDetail,
                                   String sellerAccountBankCode,
                                   String sellerAccountNumber,
                                   String deliveryRecipientName,
                                   String deliveryRecipientTel,
                                   String deliveryAddressZipCode,
                                   String deliveryAddress,
                                   String deliveryAddressDetail,
                                   String trackingNumber,
                                   @NotNull LocalDateTime createTime) {
    public static TradeChatResponseDto from(Trade trade) {
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
                .buyerId(trade.getBuyer() == null ? null : trade.getBuyer().getId())
                .directTradeTime(trade.getDirectTradeTime())
                .directTradeLocationDetail(trade.getDirectTradeLocationDetail())
                .sellerAccountBankCode(trade.getSellerAccountBankCode())
                .sellerAccountNumber(trade.getSellerAccountNumber())
                .deliveryRecipientName(trade.getDeliveryRecipientName())
                .deliveryRecipientTel(trade.getDeliveryRecipientTel())
                .deliveryAddressZipCode(trade.getDeliveryAddressZipCode())
                .deliveryAddress(trade.getDeliveryAddress())
                .deliveryAddressDetail(trade.getDeliveryAddressDetail())
                .trackingNumber(trade.getTrackingNumber())
                .createTime(trade.getCreateTime())
                .build();
    }
}
