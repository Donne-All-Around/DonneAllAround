package com.sturdy.moneyallaround.domain.trade.dto.response;

import com.sturdy.moneyallaround.domain.trade.entity.TradeReview;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;

public record TradeReviewResponseDto(@NotNull Long reviewerId,
                                     @NotNull String reviewerNickname,
                                     @NotNull String comment,
                                     @NotNull LocalDateTime createTime) {
    public static TradeReviewResponseDto from(TradeReview tradeReview) {
        return new TradeReviewResponseDto(
                tradeReview.getReviewer().getId(),
                tradeReview.getReviewer().getNickname(),
                tradeReview.getComment(),
                tradeReview.getCreateTime()
        );
    }
}
