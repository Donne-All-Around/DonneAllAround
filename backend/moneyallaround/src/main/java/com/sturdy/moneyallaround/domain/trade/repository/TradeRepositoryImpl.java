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
import static com.sturdy.moneyallaround.domain.member.entity.QMember.member;
import static com.sturdy.moneyallaround.domain.keyword.entity.QKeywordNotification.keywordNotification;

@RequiredArgsConstructor
public class TradeRepositoryImpl implements TradeRepositoryCustom {
    private final JPAQueryFactory queryFactory;

    @Override
    public Slice<Trade> findAll(TradeListRequestDto tradeListRequestDto, Long lastTradeId, Pageable pageable) {
        List<Trade> result = queryFactory
                .select(trade)
                .from(trade)
                .leftJoin(trade.seller, member)
                .fetchJoin()
                .where(
                        trade.seller.isDeleted.eq(false),
                        trade.isDeleted.eq(false),
                        trade.status.in(TradeStatus.WAIT, TradeStatus.PROGRESS),
                        trade.countryCode.eq(tradeListRequestDto.countryCode()),
                        eqTradeLocation(tradeListRequestDto.country(), tradeListRequestDto.administrativeArea(), tradeListRequestDto.subAdministrativeArea(),
                                tradeListRequestDto.locality(), tradeListRequestDto.subLocality(), tradeListRequestDto.thoroughfare()),
                        ltLastTradeId(lastTradeId, pageable)
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
                        ltLastTradeId(lastTradeId, pageable)
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
                        ltLastTradeId(lastTradeId, pageable)
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
                        ltLastTradeId(lastTradeId, pageable)
                )
                .orderBy(trade.createTime.desc())
                .limit(pageable.getPageSize() + 1)
                .fetch();

        return checkLastPage(result, pageable);
    }

    @Override
    public Slice<Trade> findLikeTradeByMember(Member member, Long lastTradeId, Pageable pageable) {
        List<Trade> result = queryFactory
                .select(trade)
                .from(tradeLike)
                .where(
                        tradeLike.member.eq(member),
                        trade.seller.isDeleted.eq(false),
                        ltLastTradeId(lastTradeId, pageable)
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
                        trade.seller.isDeleted.eq(false),
                        ltLastTradeId(lastTradeId, pageable),
                        trade.title.contains(keyword)
                                .or(trade.description.contains(keyword))
                )
                .orderBy(trade.createTime.desc())
                .limit(pageable.getPageSize())
                .fetch();

        return checkLastPage(result, pageable);
    }

    @Override
    public Slice<Trade> findNotificationTrade(Member member, Long lastTradeId, Pageable pageable) {
        List<Trade> result = queryFactory
                .select(trade)
                .from(keywordNotification)
                .where(
                        trade.seller.isDeleted.eq(false),
                        keywordNotification.member.eq(member),
                        ltLastTradeId(lastTradeId, pageable)
                )
                .orderBy(trade.createTime.desc())
                .limit(pageable.getPageSize() + 1)
                .fetch();

        return checkLastPage(result, pageable);
    }

    private BooleanExpression eqTradeLocation(String country, String administrativeArea, String subAdministrativeArea,
                                              String locality, String subLocality, String thoroughfare) {
        BooleanExpression countryExpression = country == null ? null : trade.country.eq(country);
        BooleanExpression administrativeAreaExpression = administrativeArea == null ? null : trade.administrativeArea.eq(administrativeArea);
        BooleanExpression subAdministrativeAreaExpression = subAdministrativeArea == null ? null : trade.subAdministrativeArea.eq(subAdministrativeArea);
        BooleanExpression localityExpression = locality == null ? null : trade.locality.eq(locality);
        BooleanExpression subLocalityExpression = subLocality == null ? null : trade.subLocality.eq(subLocality);
        BooleanExpression thoroughfareExpression = thoroughfare == null ? null : trade.thoroughfare.eq(thoroughfare);

        return Expressions.allOf(countryExpression, administrativeAreaExpression, subAdministrativeAreaExpression, localityExpression, subLocalityExpression, thoroughfareExpression);
    }

    private BooleanExpression ltLastTradeId(Long lastTradeId, Pageable pageable) {
        for (Sort.Order order : pageable.getSort()) {
            switch (order.getProperty()) {
                case "createTime" -> {
                    return lastTradeId == null ? null : trade.id.lt(lastTradeId);
                }
                case "koreanWonAmount" -> {
                    if (lastTradeId == null) {
                        return null;
                    }

                    Integer lastTradeKoreanWon = queryFactory
                            .select(trade.koreanWonAmount)
                            .from(trade)
                            .where(
                                    trade.id.eq(lastTradeId)
                            )
                            .fetchOne();

                    return trade.koreanWonAmount.gt(lastTradeKoreanWon)
                            .or(trade.koreanWonAmount.eq(lastTradeKoreanWon).and(trade.id.lt(lastTradeId)));
                }
                case "koreanWonPerForeignCurrency" -> {
                    if (lastTradeId == null) {
                        return null;
                    }

                    Double lastTradeKoreanWonPerForeignCurrency = queryFactory
                            .select(trade.koreanWonPerForeignCurrency)
                            .from(trade)
                            .where(
                                    trade.id.eq(lastTradeId)
                            )
                            .fetchOne();

                    return trade.koreanWonPerForeignCurrency.gt(lastTradeKoreanWonPerForeignCurrency)
                            .or(trade.koreanWonPerForeignCurrency.eq(lastTradeKoreanWonPerForeignCurrency).and(trade.id.lt(lastTradeId)));
                }
            }
        }

        return lastTradeId == null ? null : trade.id.lt(lastTradeId);
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
                case "koreanWonPerForeignCurrency" -> {
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
