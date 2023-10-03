package com.sturdy.moneyallaround.domain.keyword.repository;

import com.sturdy.moneyallaround.domain.keyword.entity.Keyword;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;

import java.util.List;

public interface KeywordRepositoryCustom {
    List<Keyword> findByCountryCodeAndLocation(Trade trade);
    Boolean existsByMemberAndLocationAndCountryCode(String countryCode, String country, String administrativeArea, String subAdministrativeArea, String locality, String subLocality, String thoroughfare, Member member);
}
