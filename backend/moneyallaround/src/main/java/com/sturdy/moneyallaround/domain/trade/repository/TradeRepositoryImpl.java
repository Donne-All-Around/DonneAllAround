package com.sturdy.moneyallaround.domain.trade.repository;

import com.querydsl.core.types.Order;
import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import com.sturdy.moneyallaround.domain.trade.dto.request.TradeListRequestDto;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.entity.TradeStatus;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;

import java.util.List;

import static com.sturdy.moneyallaround.domain.trade.entity.QTrade.trade;
import static com.sturdy.moneyallaround.domain.trade.entity.QTradeLike.tradeLike;

@RequiredArgsConstructor
public class TradeRepositoryImpl implements TradeRepositoryCustom {
    private final JPAQueryFactory queryFactory;

    @Override
    public Slice<Trade> findAll(TradeListRequestDto tradeListRequestDto, Pageable pageable) {
        List<Trade> result = queryFactory
                .selectFrom(trade)
                .where(
                        trade.isDeleted.eq(false),
                        trade.status.in(TradeStatus.WAIT, TradeStatus.PROGRESS),
                        trade.countryCode.eq(tradeListRequestDto.countryCode()),
                        eqPreferredTradeLocation(tradeListRequestDto.preferredTradeCountry(), tradeListRequestDto.preferredTradeCity(), tradeListRequestDto.preferredTradeDistrict(), tradeListRequestDto.preferredTradeTown()),
                        ltLastTradeId(tradeListRequestDto.lastTradeId()),
                        gtLastTradeKoreanWon(tradeListRequestDto.lastTradeKoreanWon()),
                        gtLastTradeKoreanWonPerForeignCurrency(tradeListRequestDto.lastTradeForeignCurrencyPerKoreanWon())
                )
                .limit(pageable.getPageSize() + 1)
                .orderBy(tradeSort(pageable), trade.createTime.desc())
                .fetch();

        return checkLastPage(result, pageable);
    }

    @Override
    public Slice<Trade> findCompleteTradeBySeller(Member seller, Long lastTradeId, Pageable pageable) {
        List<Trade> result = queryFactory
                .selectFrom(trade)
                .where(
                        trade.seller.eq(seller),
                        trade.status.eq(TradeStatus.COMPLETE),
                        ltLastTradeId(lastTradeId)
                )
                .orderBy(trade.createTime.desc())
                .limit(pageable.getPageSize() + 1)
                .fetch();

        return checkLastPage(result, pageable);
    }

    @Override
    public Slice<Trade> findSaleTradeBySeller(Member seller, Long lastTradeId, Pageable pageable) {
        List<Trade> result = queryFactory
                .selectFrom(trade)
                .where(
                        trade.seller.eq(seller),
                        trade.status.ne(TradeStatus.COMPLETE),
                        ltLastTradeId(lastTradeId)
                )
                .orderBy(trade.createTime.desc())
                .limit(pageable.getPageSize() + 1)
                .fetch();

        return checkLastPage(result, pageable);
    }

    @Override
    public Slice<Trade> findByBuyerAndStatus(Member buyer, Long lastTradeId, Pageable pageable) {
        List<Trade> result = queryFactory
                .selectFrom(trade)
                .where(
                        trade.buyer.eq(buyer),
                        trade.status.eq(TradeStatus.COMPLETE),
                        ltLastTradeId(lastTradeId)
                )
                .orderBy(trade.createTime.desc())
                .limit(pageable.getPageSize() + 1)
                .fetch();

        return checkLastPage(result, pageable);
    }

    @Override
    public Slice<Trade> findLikeTradeByMember(Member member, Long lastTradeId, Pageable pageable) {
        List<Trade> result = queryFactory
                .selectFrom(trade)
                .join(tradeLike.trade, trade)
                .where(
                        tradeLike.member.eq(member),
                        ltLastTradeId(lastTradeId)
                )
                .orderBy(trade.createTime.desc())
                .limit(pageable.getPageSize() + 1)
                .fetch();

        return checkLastPage(result, pageable);
    }

    @Override
    public Slice<Trade> findByKeyword(String keyword, Long lastTradeId, Pageable pageable) {
        List<Trade> result = queryFactory
                .selectFrom(trade)
                .where(
                        ltLastTradeId(lastTradeId),
                        trade.title.contains(keyword)
                                .or(trade.description.contains(keyword))
                )
                .orderBy(trade.createTime.desc())
                .limit(pageable.getPageSize())
                .fetch();

        return checkLastPage(result, pageable);
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

    private BooleanExpression gtLastTradeKoreanWonPerForeignCurrency(Double lastTradeKoreanWonPerForeignCurrency) {
        return lastTradeKoreanWonPerForeignCurrency == null ? null : trade.koreanWonPerForeignCurrency.gt(lastTradeKoreanWonPerForeignCurrency);
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
                    return new OrderSpecifier<>(Order.ASC, trade.koreanWonPerForeignCurrency);
                }
            }
        }

        return null;
    }

    private Slice<Trade> checkLastPage(List<Trade> result, Pageable pageable) {
        boolean hasNext = false;

        if (result.size() > pageable.getPageSize()) {
            hasNext = true;
            result.remove(pageable.getPageSize());
        }

        return new SliceImpl<>(result, pageable, hasNext);
    }
}
