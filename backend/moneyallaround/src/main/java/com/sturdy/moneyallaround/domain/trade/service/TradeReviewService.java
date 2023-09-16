package com.sturdy.moneyallaround.domain.trade.service;

import com.sturdy.moneyallaround.domain.member.entity.Member;
import com.sturdy.moneyallaround.domain.member.service.MemberService;
import com.sturdy.moneyallaround.domain.trade.dto.request.TradeReviewRequestDto;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
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
    public void createTradeReview(Long tradeId, Long reviewerId, TradeReviewRequestDto tradeReviewRequestDto) {
        /*
            라연 : 후기 평가 점수 계산
         */
        tradeReviewRepository.save(tradeReviewRequestDto.toTradeReview(tradeService.findTrade(tradeId), memberService.findById(reviewerId), memberService.findById(tradeReviewRequestDto.revieweeId())));
    }

    public Slice<TradeReview> findTradeReview(Long reviweeId, Long lastTradeId, Pageable pageable) {
        return tradeReviewRepository.findByReviewee(memberService.findById(reviweeId), lastTradeId, pageable);
    }

    public Map<String, Integer> countScore(Long revieweeId) {
        Member member = memberService.findById(revieweeId);

        Map<String, Integer> map = new HashMap<>();
        map.put("bad", tradeReviewRepository.countByRevieweeAndScore(member, -1));
        map.put("good", tradeReviewRepository.countByRevieweeAndScore(member, 1));
        map.put("veryGood", tradeReviewRepository.countByRevieweeAndScore(member, 2));

        return map;
    }

    public Boolean existTradeReview(Long tradeId, Long reviewerId) {
        return tradeReviewRepository.existsByTradeAndReviewer(tradeService.findTrade(tradeId), memberService.findById(reviewerId));
    }
}
