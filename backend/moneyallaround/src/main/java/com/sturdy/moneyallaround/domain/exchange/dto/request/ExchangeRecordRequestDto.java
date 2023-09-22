package com.sturdy.moneyallaround.domain.exchange.dto.request;

import com.sturdy.moneyallaround.domain.exchange.entity.ExchangeRecord;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;

public record ExchangeRecordRequestDto(@NotNull String countryCode,
                                       @NotNull String bankCode,
                                       @NotNull Integer koreanWonAmount,
                                       @NotNull Integer foreignCurrencyAmount,
                                       @NotNull Float tradingBaseRate,
                                       @NotNull Integer preferentialRate,
                                       @NotNull LocalDate exchangeDate) {
    public ExchangeRecord toExchangeRecord(Member member) {
        return ExchangeRecord.builder()
                .countryCode(countryCode)
                .bankCode(bankCode)
                .koreanWonAmount(koreanWonAmount)
                .foreignCurrencyAmount(foreignCurrencyAmount)
                .tradingBaseRate(tradingBaseRate)
                .preferentialRate(preferentialRate)
                .exchangeDate(exchangeDate)
                .member(member)
                .build();
    }
}
