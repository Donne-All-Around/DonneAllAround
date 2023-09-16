package com.sturdy.moneyallaround.domain.trade.repository;

import com.sturdy.moneyallaround.domain.trade.entity.TradeImage;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TradeImageRepository extends JpaRepository<TradeImage, Long> {
    void deleteByTradeId(Long tradeId);
}
