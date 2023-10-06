package com.sturdy.moneyallaround.domain.transfer.repository;

import com.querydsl.jpa.impl.JPAQueryFactory;
import com.sturdy.moneyallaround.domain.transfer.entity.Transfer;
import lombok.RequiredArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

import static com.sturdy.moneyallaround.domain.transfer.entity.QTransfer.transfer;

@RequiredArgsConstructor
public class TransferRepositoryImpl implements TransferRepositoryCustom {
    private final JPAQueryFactory queryFactory;

    @Override
    public List<Transfer> findByCreatedTime() {
        return queryFactory
                .selectFrom(transfer)
                .where(
                    transfer.createTime.before(LocalDateTime.now().minusDays(10))
                )
                .fetch();
    }
}
