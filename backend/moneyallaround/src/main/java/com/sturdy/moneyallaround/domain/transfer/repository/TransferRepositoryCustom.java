package com.sturdy.moneyallaround.domain.transfer.repository;

import com.sturdy.moneyallaround.domain.transfer.entity.Transfer;

import java.util.List;

public interface TransferRepositoryCustom {
    List<Transfer> findByCreatedTime();
}
