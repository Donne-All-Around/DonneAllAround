package com.sturdy.moneyallaround.domain.trade.service;

import com.sturdy.moneyallaround.domain.member.service.MemberService;
import com.sturdy.moneyallaround.domain.trade.entity.TradeLike;
import com.sturdy.moneyallaround.domain.trade.repository.TradeLikeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class TradeLikeService {
    private final TradeLikeRepository tradeLikeRepository;
    private final TradeService tradeService;
    private final MemberService memberService;

    public Boolean existTradeLike(Long tradeId, Long memberId) {
        return tradeLikeRepository.existsByTradeIdAndMemberId(tradeId, memberId);
    }

    public void like(Long tradeId, Long memberId) {
        tradeLikeRepository.save(new TradeLike(tradeService.findTrade(tradeId), memberService.findById(memberId)));
    }

    public void unlike(Long tradeId, Long memberId) {
        tradeLikeRepository.deleteByTradeIdAndMemberId(tradeId, memberId);
    }
}
