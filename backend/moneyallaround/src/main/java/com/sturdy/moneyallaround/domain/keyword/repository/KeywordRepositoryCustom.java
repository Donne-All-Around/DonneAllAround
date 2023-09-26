package com.sturdy.moneyallaround.domain.keyword.repository;

import com.sturdy.moneyallaround.domain.keyword.entity.Keyword;

import java.util.List;

public interface KeywordRepositoryCustom {
    List<Keyword> findByCountryCodeAndPreferredTradeLocation(String countryCode, String preferredTradeCountry, String preferredTradeCity, String preferredTradeDistrict, String preferredTradeTown);

}
