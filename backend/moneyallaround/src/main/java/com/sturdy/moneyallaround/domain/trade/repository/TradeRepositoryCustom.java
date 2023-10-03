package com.sturdy.moneyallaround.domain.trade.repository;

import com.sturdy.moneyallaround.domain.member.entity.Member;
import com.sturdy.moneyallaround.domain.trade.dto.request.TradeListRequestDto;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;

public interface TradeRepositoryCustom {
    Slice<Trade> findAll(TradeListRequestDto tradeListRequestDto, Long lastTradeId, Pageable pageable);
    Slice<Trade> findCompleteTradeBySeller(Member seller, Long lastTradeId, Pageable pageable);
    Slice<Trade> findSaleTradeBySeller(Member seller, Long lastTradeId, Pageable pageable);
    Slice<Trade> findByBuyerAndStatus(Member buyer, Long lastTradeId, Pageable pageable);
    Slice<Trade> findLikeTradeByMember(Member member, Long lastTradeId, Pageable pageable);
    Slice<Trade> findByKeyword(String keyword, Long lastTradeId, Pageable pageable);
    Slice<Trade> findNotificationTrade(Member member, Long lastTradeId, Pageable pageable);
}
