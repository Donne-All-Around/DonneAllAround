package com.sturdy.moneyallaround.domain.trade.dto.request;

import jakarta.validation.constraints.NotNull;

public record DeliveryInfoRequestDto(@NotNull String deliveryRecipientName,
                                     @NotNull String deliveryRecipientTel,
                                     @NotNull String deliveryAddressZipCode,
                                     @NotNull String deliveryAddress,
                                     String deliveryAddressDetail) {
}
