package com.sturdy.moneyallaround.domain.trade.repository;

import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.entity.TradeReview;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;

import java.util.List;

import static com.sturdy.moneyallaround.domain.trade.entity.QTradeReview.tradeReview;
import static com.sturdy.moneyallaround.domain.trade.entity.QTrade.trade;

@RequiredArgsConstructor
public class TradeReviewRepositoryImpl implements TradeReviewRepositoryCustom {
    private final JPAQueryFactory queryFactory;

    @Override
    public Slice<TradeReview> findSellReviewByReviewee(Member reviewee, Long lastTradeReviewId, Pageable pageable) {
        List<TradeReview> result = queryFactory
                .selectFrom(tradeReview)
                .where(
                        tradeReview.reviewee.eq(reviewee),
                        tradeReview.trade.seller.eq(reviewee),
                        tradeReview.comment.isNotNull(),
                        ltLastTradeReviewId(lastTradeReviewId)
                )
                .limit(pageable.getPageSize() + 1)
                .orderBy(tradeReview.createTime.desc())
                .fetch();

        return checkLastPage(result, pageable);
    }

    @Override
    public Slice<TradeReview> findBuyReviewByReviewee(Member reviewee, Long lastTradeReviewId, Pageable pageable) {
        List<TradeReview> result = queryFactory
                .selectFrom(tradeReview)
                .join(tradeReview.trade, trade)
                .where(
                        tradeReview.reviewee.eq(reviewee),
                        tradeReview.trade.buyer.eq(reviewee),
                        tradeReview.comment.isNotNull(),
                        ltLastTradeReviewId(lastTradeReviewId)
                )
                .limit(pageable.getPageSize() + 1)
                .orderBy(tradeReview.createTime.desc())
                .fetch();

        return checkLastPage(result, pageable);
    }

    private BooleanExpression ltLastTradeReviewId(Long lastTradeReviewId) {
        return lastTradeReviewId == null ? null : tradeReview.id.lt(lastTradeReviewId);
    }

    private Slice<TradeReview> checkLastPage(List<TradeReview> result, Pageable pageable) {
        boolean hasNext = false;

        if (result.size() > pageable.getPageSize()) {
            hasNext = true;
            result.remove(pageable.getPageSize());
        }

        return new SliceImpl<>(result, pageable, hasNext);
    }
}
