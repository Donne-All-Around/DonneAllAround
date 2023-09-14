package com.sturdy.moneyallaround.domain.trade.repository;

import com.querydsl.core.types.Expression;
import com.querydsl.core.types.Order;
import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.core.types.dsl.NumberExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import com.sturdy.moneyallaround.domain.trade.dto.request.TradeListRequestDto;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.entity.TradeStatus;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;

import java.util.List;

import static com.sturdy.moneyallaround.domain.trade.entity.QTrade.trade;

@RequiredArgsConstructor
public class TradeRepositoryImpl implements TradeRepositoryCustom {
    private final JPAQueryFactory queryFactory;

    @Override
    public Slice<Trade> findAll(TradeListRequestDto tradeListRequestDto, Pageable pageable) {
        List<Trade> result = queryFactory
                .selectFrom(trade)
                .where(
                        trade.status.in(TradeStatus.WAIT, TradeStatus.PROGRESS),
                        trade.countryCode.eq(tradeListRequestDto.countryCode()),
                        eqPreferredTradeLocation(tradeListRequestDto.preferredTradeCountry(), tradeListRequestDto.preferredTradeCity(), tradeListRequestDto.preferredTradeDistrict(), tradeListRequestDto.preferredTradeTown()),
                        ltLastTradeId(tradeListRequestDto.lastTradeId()),
                        gtLastTradeKoreanWon(tradeListRequestDto.lastTradeKoreanWon()),
                        gtLastTradeForeignCurrencyPerKoreanWon(tradeListRequestDto.lastTradeForeignCurrencyPerKoreanWon())
                )
                .limit(pageable.getPageSize() + 1)
                .orderBy(tradeSort(pageable), trade.createTime.desc())
                .fetch();

        boolean hasNext = false;
        if (result.size() > pageable.getPageSize()) {
            result.remove(pageable.getPageSize());
            hasNext = true;
        }

        return new SliceImpl<>(result, pageable, hasNext);
    }

    @Override
    //public Slice<Trade> findBySellerAndStatus(Long lastTradeId, Member seller, TradeStatus status, Pageable pageable) {
    public Slice<Trade> findBySellerAndStatus(Long lastTradeId, TradeStatus status, Pageable pageable) {
        List<Trade> result = queryFactory
                .selectFrom(trade)
                .where(
                        //trade.seller.eq(seller),
                        trade.status.eq(status),
                        ltLastTradeId(lastTradeId)
                )
                .orderBy(trade.createTime.desc())
                .limit(pageable.getPageSize())
                .fetch();

        boolean hasNext = false;

        if (result.size() > pageable.getPageSize()) {
            hasNext = true;
            result.remove(pageable.getPageSize());
        }

        return new SliceImpl<>(result, pageable, hasNext);
    }

    private BooleanExpression eqPreferredTradeLocation(String preferredTradeCountry, String preferredTradeCity, String preferredTradeDistrict, String preferredTradeTown) {
        BooleanExpression countryExpression = trade.preferredTradeCountry.eq(preferredTradeCountry);
        BooleanExpression cityExpression = trade.preferredTradeCity.eq(preferredTradeCity);
        BooleanExpression districtExpression = trade.preferredTradeDistrict.eq(preferredTradeDistrict);
        BooleanExpression townExpression = trade.preferredTradeTown.eq(preferredTradeTown);

        return Expressions.allOf(countryExpression, cityExpression, districtExpression, townExpression);
    }

    private BooleanExpression ltLastTradeId(Long lastTradeId) {
        return lastTradeId == null ? null : trade.id.lt(lastTradeId);
    }

    private BooleanExpression gtLastTradeKoreanWon(Double lastTradeKoreanWon) {
        return lastTradeKoreanWon == null ? null : trade.koreanWonAmount.gt(lastTradeKoreanWon);
    }

    private BooleanExpression gtLastTradeForeignCurrencyPerKoreanWon(Double lastTradeForeignCurrencyPerKoreanWon) {
        if (lastTradeForeignCurrencyPerKoreanWon == null) {
            return null;
        }

        NumberExpression<Double> foreignCurrencyPerKoreanWon = trade.koreanWonAmount.doubleValue()
                .divide(trade.foreignCurrencyAmount.doubleValue());
        return foreignCurrencyPerKoreanWon.gt(lastTradeForeignCurrencyPerKoreanWon);
    }

    private OrderSpecifier<?> tradeSort(Pageable pageable) {
        for (Sort.Order order : pageable.getSort()) {
            switch (order.getProperty()) {
                case "createTime" -> {
                    return new OrderSpecifier<>(Order.DESC, trade.createTime);
                }
                case "koreanWonAmount" -> {
                    return new OrderSpecifier<>(Order.ASC, trade.koreanWonAmount);
                }
                case "foreignCurrencyPerKoreanWon" -> {
                    Expression<Double> foreignCurrencyPerKoreanWon = trade.koreanWonAmount.doubleValue()
                            .divide(trade.foreignCurrencyAmount.doubleValue());
                    return new OrderSpecifier<>(Order.ASC, foreignCurrencyPerKoreanWon);
                }
            }
        }

        return null;
    }
}
