package com.sturdy.moneyallaround.domain.trade.service;

import com.sturdy.moneyallaround.domain.trade.repository.TradeLikeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class TradeLikeService {
    private final TradeLikeRepository tradeLikeRepository;

    public Boolean existTradeLike(Long tradeId, Long memberId) {
        return tradeLikeRepository.existsByTradeIdAndMemberId(tradeId, memberId);
    }
}
