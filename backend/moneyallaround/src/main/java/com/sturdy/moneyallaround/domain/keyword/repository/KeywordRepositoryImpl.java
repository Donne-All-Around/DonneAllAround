package com.sturdy.moneyallaround.domain.keyword.repository;

import com.querydsl.jpa.impl.JPAQueryFactory;
import com.sturdy.moneyallaround.domain.keyword.entity.Keyword;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import lombok.RequiredArgsConstructor;

import java.util.List;

import static com.sturdy.moneyallaround.domain.keyword.entity.QKeyword.keyword;

@RequiredArgsConstructor
public class KeywordRepositoryImpl implements KeywordRepositoryCustom {
    private final JPAQueryFactory queryFactory;

    @Override
    public List<Keyword> findByCountryCodeAndPreferredTradeLocation(Trade trade) {
        return queryFactory
                .selectFrom(keyword)
                .where(
                        keyword.member.ne(trade.getSeller()),
                        keyword.countryCode.eq(trade.getCountryCode()),
                        keyword.preferredTradeCountry.eq(trade.getCountry()),
                        keyword.preferredTradeCity.eq(trade.getAdministrativeArea()),
                        keyword.preferredTradeDistrict.eq(trade.getSubAdministrativeArea()),
                        keyword.preferredTradeTown.eq(trade.getLocality()),
                        keyword.preferredTradeTown.eq(trade.getSubLocality())
                )
                .fetch();
    }
}