package com.sturdy.moneyallaround.domain.exchange.repository;

import com.sturdy.moneyallaround.domain.exchange.entity.ExchangeRecord;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ExchangeRecordRepository extends JpaRepository<ExchangeRecord, Long>, ExchangeRecordRepositoryCustom {
}
