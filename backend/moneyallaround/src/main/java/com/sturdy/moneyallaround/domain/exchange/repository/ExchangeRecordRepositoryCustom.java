package com.sturdy.moneyallaround.domain.exchange.repository;

import com.sturdy.moneyallaround.domain.exchange.entity.ExchangeRecord;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;

public interface ExchangeRecordRepositoryCustom {
    Slice<ExchangeRecord> findByMember(Member member, Long lastExchangeRecordId, Pageable pageable);
}
