package com.sturdy.moneyallaround.domain.trade.dto.request;

import jakarta.validation.constraints.NotNull;

public record TradeListRequestDto(@NotNull String countryCode,
                                  String country,
                                  String administrativeArea,
                                  String subAdministrativeArea,
                                  String locality,
                                  String subLocality,
                                  String thoroughfare) {
}
