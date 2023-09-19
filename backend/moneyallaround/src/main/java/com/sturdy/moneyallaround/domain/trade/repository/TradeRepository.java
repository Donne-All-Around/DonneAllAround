package com.sturdy.moneyallaround.domain.trade.repository;

import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TradeRepository extends JpaRepository<Trade, Long>, TradeRepositoryCustom {
}
