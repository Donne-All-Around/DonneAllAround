package com.sturdy.moneyallaround.domain.transfer.repository;

import com.sturdy.moneyallaround.domain.transfer.entity.Transfer;
import org.jetbrains.annotations.NotNull;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TransferRepository extends JpaRepository<Transfer, Long> {
    void deleteById(@NotNull Long id);
    Transfer findByTradeId(Long tradeId);
    Boolean existsByTradeId(Long tradeId);
}
