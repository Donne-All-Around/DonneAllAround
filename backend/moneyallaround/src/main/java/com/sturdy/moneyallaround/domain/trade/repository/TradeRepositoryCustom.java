package com.sturdy.moneyallaround.domain.trade.repository;

import com.sturdy.moneyallaround.domain.member.entity.Member;
import com.sturdy.moneyallaround.domain.trade.dto.request.TradeListRequestDto;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.entity.TradeStatus;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;

public interface TradeRepositoryCustom {
    Slice<Trade> findAll(TradeListRequestDto tradeListRequestDto, Pageable pageable);
    //Slice<Trade> findBySellerAndStatus(Long lastTradeId, Member seller, TradeStatus status, Pageable pageable);
    Slice<Trade> findBySellerAndStatus(Long lastTradeId, TradeStatus status, Pageable pageable);
}
