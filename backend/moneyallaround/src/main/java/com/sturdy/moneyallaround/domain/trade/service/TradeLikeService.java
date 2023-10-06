package com.sturdy.moneyallaround.domain.trade.service;

import com.sturdy.moneyallaround.domain.member.entity.Member;
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

    public Boolean existTradeLike(Long tradeId, String memberTel) {
        Member member = memberService.findByTel(memberTel);
        return tradeLikeRepository.existsByTradeIdAndMemberId(tradeId, member.getId());
    }

    public void like(Long tradeId, String memberTel) {
        tradeLikeRepository.save(new TradeLike(tradeService.findTrade(tradeId), memberService.findByTel(memberTel)));
    }

    public void unlike(Long tradeId, String memberTel) {
        Member member = memberService.findByTel(memberTel);
        TradeLike tradeLike = tradeLikeRepository.findByTradeIdAndMemberId(tradeId, member.getId());
        tradeLikeRepository.delete(tradeLike);
        tradeLikeRepository.flush();
    }
}
