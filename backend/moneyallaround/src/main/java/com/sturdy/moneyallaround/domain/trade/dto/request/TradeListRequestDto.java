package com.sturdy.moneyallaround.domain.trade.dto.request;

import jakarta.validation.constraints.NotNull;

public record TradeListRequestDto(@NotNull String countryCode,
                                  String preferredTradeCountry,
                                  String preferredTradeCity,
                                  String preferredTradeDistrict,
                                  String preferredTradeTown,
                                  Long lastTradeId) {
}
