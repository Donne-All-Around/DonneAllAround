package com.sturdy.moneyallaround.domain.keyword.repository;

import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.sturdy.moneyallaround.domain.keyword.entity.Keyword;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import lombok.RequiredArgsConstructor;

import java.util.List;

import static com.sturdy.moneyallaround.domain.keyword.entity.QKeyword.keyword;

@RequiredArgsConstructor
public class KeywordRepositoryImpl implements KeywordRepositoryCustom {
    private final JPAQueryFactory queryFactory;

    @Override
    public List<Keyword> findByCountryCodeAndLocation(Trade trade) {
        return queryFactory
                .selectFrom(keyword)
                .where(
                        keyword.member.ne(trade.getSeller()),
                        keyword.countryCode.eq(trade.getCountryCode()),
                        eqTradeLocation(trade.getCountry(), trade.getAdministrativeArea(), trade.getSubAdministrativeArea(),
                                trade.getLocality(), trade.getSubLocality(), trade.getThoroughfare())
                )
                .fetch();
    }

    @Override
    public Boolean existsByMemberAndLocationAndCountryCode(String countryCode,
                                                           String country, String administrativeArea, String subAdministrativeArea,
                                                           String locality, String subLocality, String thoroughfare,
                                                           Member member) {
        return queryFactory.selectFrom(keyword)
                .where(
                        keyword.member.eq(member),
                        keyword.countryCode.eq(countryCode),
                        eqTradeLocation(country, administrativeArea, subAdministrativeArea, locality, subLocality, thoroughfare)
                ).fetchFirst() != null;
    }

    private BooleanExpression eqTradeLocation(String country, String administrativeArea, String subAdministrativeArea,
                                              String locality, String subLocality, String thoroughfare) {
        BooleanExpression countryExpression = country == null ? null : keyword.country.eq(country);
        BooleanExpression administrativeAreaExpression = administrativeArea == null ? null : keyword.administrativeArea.eq(administrativeArea);
        BooleanExpression subAdministrativeAreaExpression = subAdministrativeArea == null ? null : keyword.subAdministrativeArea.eq(subAdministrativeArea);
        BooleanExpression localityExpression = locality == null ? null : keyword.locality.eq(locality);
        BooleanExpression subLocalityExpression = subLocality == null ? null : keyword.subLocality.eq(subLocality);
        BooleanExpression thoroughfareExpression = thoroughfare == null ? null : keyword.thoroughfare.eq(thoroughfare);

        return Expressions.allOf(countryExpression, administrativeAreaExpression, subAdministrativeAreaExpression, localityExpression, subLocalityExpression, thoroughfareExpression);
    }
}