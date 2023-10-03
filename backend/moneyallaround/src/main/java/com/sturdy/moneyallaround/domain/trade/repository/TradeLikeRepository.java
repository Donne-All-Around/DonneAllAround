package com.sturdy.moneyallaround.domain.trade.repository;

import com.sturdy.moneyallaround.domain.trade.entity.TradeLike;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TradeLikeRepository extends JpaRepository<TradeLike, Long> {
    Boolean existsByTradeIdAndMemberId(Long tradeId, Long memberId);
    void deleteByTradeIdAndMemberId(Long tradeId, Long memberId);
    TradeLike findByTradeIdAndMemberId(Long tradeId, Long memberId);
}
