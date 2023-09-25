package com.sturdy.moneyallaround.domain.trade.repository;

import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import com.sturdy.moneyallaround.domain.trade.entity.TradeReview;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;

import java.util.List;

import static com.sturdy.moneyallaround.domain.trade.entity.QTradeReview.tradeReview;

@RequiredArgsConstructor
public class TradeReviewRepositoryImpl implements TradeReviewRepositoryCustom {
    private final JPAQueryFactory queryFactory;

    @Override
    public Slice<TradeReview> findByReviewee(Member reviewee, Long lastTradeId, Pageable pageable) {
        List<TradeReview> result = queryFactory
                .selectFrom(tradeReview)
                .where(
                        tradeReview.reviewee.eq(reviewee),
                        ltLastTradeId(lastTradeId)
                )
                .limit(pageable.getPageSize() + 1)
                .orderBy(tradeReview.createTime.desc())
                .fetch();

        return checkLastPage(result, pageable);
    }

    private BooleanExpression ltLastTradeId(Long lastTradeId) {
        return lastTradeId == null ? null : tradeReview.id.lt(lastTradeId);
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
