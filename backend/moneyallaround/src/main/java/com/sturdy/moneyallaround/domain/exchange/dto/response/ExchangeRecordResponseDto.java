package com.sturdy.moneyallaround.domain.exchange.dto.response;

import com.sturdy.moneyallaround.domain.exchange.entity.ExchangeRecord;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;

import java.time.LocalDate;

@Builder
public record ExchangeRecordResponseDto(@NotNull Long id,
                                        @NotNull String countryCode,
                                        @NotNull String bankCode,
                                        @NotNull Integer koreanWonAmount,
                                        @NotNull Integer foreignCurrencyAmount,
                                        @NotNull Float tradingBaseRate,
                                        @NotNull Integer preferentialRate,
                                        @NotNull LocalDate exchangeDate) {
    public static ExchangeRecordResponseDto from(ExchangeRecord exchangeRecord) {
        return ExchangeRecordResponseDto.builder()
                .id(exchangeRecord.getId())
                .countryCode(exchangeRecord.getCountryCode())
                .bankCode(exchangeRecord.getBankCode())
                .koreanWonAmount(exchangeRecord.getKoreanWonAmount())
                .foreignCurrencyAmount(exchangeRecord.getForeignCurrencyAmount())
                .tradingBaseRate(exchangeRecord.getTradingBaseRate())
                .preferentialRate(exchangeRecord.getPreferentialRate())
                .exchangeDate(exchangeRecord.getExchangeDate())
                .build();
    }
}
