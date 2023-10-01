package com.sturdy.moneyallaround.domain.keyword.repository;

import com.sturdy.moneyallaround.domain.keyword.entity.Keyword;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;

import java.util.List;

public interface KeywordRepositoryCustom {
    List<Keyword> findByCountryCodeAndPreferredTradeLocation(Trade trade);

}
