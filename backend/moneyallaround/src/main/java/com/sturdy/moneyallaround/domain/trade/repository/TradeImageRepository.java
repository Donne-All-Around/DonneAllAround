package com.sturdy.moneyallaround.domain.trade.repository;

import com.sturdy.moneyallaround.domain.trade.entity.TradeImage;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TradeImageRepository extends JpaRepository<TradeImage, Long> {
    List<TradeImage> findByTradeId(Long tradeId);
}
