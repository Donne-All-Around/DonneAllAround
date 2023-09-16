package com.sturdy.moneyallaround.domain.trade.repository;

import com.sturdy.moneyallaround.domain.member.entity.Member;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.entity.TradeReview;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TradeReviewRepository extends JpaRepository<TradeReview, Long>, TradeReviewRepositoryCustom {
    Boolean existsByTradeAndReviewer(Trade trade, Member reviewer);
    Integer countByRevieweeAndScore(Member reviewee, Integer score);
}
