package com.sturdy.moneyallaround.domain.exchange.repository;

import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.sturdy.moneyallaround.domain.exchange.entity.ExchangeRecord;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.SliceImpl;

import java.time.LocalDate;
import java.util.List;

import static com.sturdy.moneyallaround.domain.exchange.entity.QExchangeRecord.exchangeRecord;

@RequiredArgsConstructor
public class ExchangeRecordRepositoryImpl implements ExchangeRecordRepositoryCustom {
    private final JPAQueryFactory queryFactory;

    @Override
    public Slice<ExchangeRecord> findByMember(Member member, Long lastExchangeRecordId, Pageable pageable) {
        List<ExchangeRecord> result = queryFactory
                .selectFrom(exchangeRecord)
                .where(
                        exchangeRecord.member.eq(member),
                        ltLastExchangeRecordId(lastExchangeRecordId)
                )
                .limit(pageable.getPageSize() + 1)
                .orderBy(exchangeRecord.exchangeDate.desc(), exchangeRecord.createTime.desc())
                .fetch();

        return checkLastPage(result, pageable);
    }

    private BooleanExpression ltLastExchangeRecordId(Long lastExchangeRecordId) {
        if (lastExchangeRecordId == 0) {
            return null;
        }

        LocalDate lastExchangeRecordDate = queryFactory
                .select(exchangeRecord.exchangeDate)
                .from(exchangeRecord)
                .where(
                        exchangeRecord.id.eq(lastExchangeRecordId)
                )
                .fetchOne();

        return exchangeRecord.exchangeDate.lt(lastExchangeRecordDate)
                .or(exchangeRecord.exchangeDate.eq(lastExchangeRecordDate).and(exchangeRecord.id.lt(lastExchangeRecordId)));
    }

    private Slice<ExchangeRecord> checkLastPage(List<ExchangeRecord> result, Pageable pageable) {
        boolean hasNext = false;

        if (result.size() > pageable.getPageSize()) {
            hasNext = true;
            result.remove(pageable.getPageSize());
        }

        return new SliceImpl<>(result, pageable, hasNext);
    }
}
