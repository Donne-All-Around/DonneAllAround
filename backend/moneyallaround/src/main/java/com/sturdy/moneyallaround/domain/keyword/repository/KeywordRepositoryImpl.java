package com.sturdy.moneyallaround.domain.keyword.repository;

import com.querydsl.jpa.impl.JPAQueryFactory;
import com.sturdy.moneyallaround.domain.keyword.entity.Keyword;
import lombok.RequiredArgsConstructor;

import java.util.List;

import static com.sturdy.moneyallaround.domain.keyword.entity.QKeyword.keyword;

@RequiredArgsConstructor
public class KeywordRepositoryImpl implements KeywordRepositoryCustom {
    private final JPAQueryFactory queryFactory;

    @Override
    public List<Keyword> findByCountryCodeAndPreferredTradeLocation(String countryCode, String preferredTradeCountry, String preferredTradeCity, String preferredTradeDistrict, String preferredTradeTown) {
        return queryFactory
                .selectFrom(keyword)
                .where(
                        keyword.countryCode.eq(countryCode),
                        keyword.preferredTradeCountry.eq(preferredTradeCountry),
                        keyword.preferredTradeCity.eq(preferredTradeCity),
                        keyword.preferredTradeDistrict.eq(preferredTradeDistrict),
                        keyword.preferredTradeTown.eq(preferredTradeTown)
                )
                .fetch();
    }
}