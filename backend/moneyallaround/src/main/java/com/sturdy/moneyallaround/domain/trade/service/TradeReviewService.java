package com.sturdy.moneyallaround.domain.trade.service;

import com.sturdy.moneyallaround.domain.member.entity.Member;
import com.sturdy.moneyallaround.domain.member.service.MemberService;
import com.sturdy.moneyallaround.domain.trade.dto.request.TradeReviewRequestDto;
import com.sturdy.moneyallaround.domain.trade.entity.TradeReview;
import com.sturdy.moneyallaround.domain.trade.repository.TradeReviewRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class TradeReviewService {
    private final TradeReviewRepository tradeReviewRepository;
    private final TradeService tradeService;
    private final MemberService memberService;

    @Transactional
    public void createTradeReview(Long tradeId, String memberTel, TradeReviewRequestDto tradeReviewRequestDto) {
        tradeReviewRepository.save(tradeReviewRequestDto.toTradeReview(tradeService.findTrade(tradeId), memberService.findByTel(memberTel), memberService.findById(tradeReviewRequestDto.revieweeId())));
        memberService.updateRating(tradeReviewRequestDto.revieweeId(), tradeReviewRequestDto.score());
    }

    public Slice<TradeReview> findSellReview(String memberTel, Long lastTradeId, Pageable pageable) {
        return tradeReviewRepository.findSellReviewByReviewee(memberService.findByTel(memberTel), lastTradeId, pageable);
    }

    public Slice<TradeReview> findBuyReview(String memberTel, Long lastTradeId, Pageable pageable) {
        return tradeReviewRepository.findBuyReviewByReviewee(memberService.findByTel(memberTel), lastTradeId, pageable);
    }

    public Map<String, Integer> countScore(String memberTel) {
        Member member = memberService.findByTel(memberTel);

        Map<String, Integer> map = new HashMap<>();
        map.put("bad", tradeReviewRepository.countByRevieweeAndScore(member, -1));
        map.put("good", tradeReviewRepository.countByRevieweeAndScore(member, 1));
        map.put("veryGood", tradeReviewRepository.countByRevieweeAndScore(member, 2));

        return map;
    }

    public Boolean existTradeReview(Long tradeId, String memberTel) {
        return tradeReviewRepository.existsByTradeAndReviewer(tradeService.findTrade(tradeId), memberService.findByTel(memberTel));
    }
}
