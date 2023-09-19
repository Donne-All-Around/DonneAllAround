package com.sturdy.moneyallaround.domain.trade.dto.request;

import com.sturdy.moneyallaround.domain.member.entity.Member;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.entity.TradeReview;
import jakarta.validation.constraints.NotNull;

public record TradeReviewRequestDto (@NotNull Long revieweeId,
                                     @NotNull Integer score,
                                     String comment){
    public TradeReview toTradeReview(Trade trade, Member reviewer, Member reviewee) {
        return new TradeReview(score, comment, trade, reviewer, reviewee);
    }
}