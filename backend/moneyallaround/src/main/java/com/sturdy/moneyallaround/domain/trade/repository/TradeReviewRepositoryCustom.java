package com.sturdy.moneyallaround.domain.trade.repository;

import com.sturdy.moneyallaround.domain.member.entity.Member;
import com.sturdy.moneyallaround.domain.trade.entity.TradeReview;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;

public interface TradeReviewRepositoryCustom {
    Slice<TradeReview> findByReviewee(Member reviewee, Long lastTradeId, Pageable pageable);
}
