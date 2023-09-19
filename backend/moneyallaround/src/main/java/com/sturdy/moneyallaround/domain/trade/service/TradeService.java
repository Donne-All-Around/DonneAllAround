package com.sturdy.moneyallaround.domain.trade.service;

import com.sturdy.moneyallaround.domain.keyword.service.KeywordNotificationService;
import com.sturdy.moneyallaround.domain.member.service.MemberService;
import com.sturdy.moneyallaround.domain.trade.dto.request.PromiseCreateRequestDto;
import com.sturdy.moneyallaround.domain.trade.dto.request.PromiseUpdateRequestDto;
import com.sturdy.moneyallaround.domain.trade.dto.request.TradeRequestDto;
import com.sturdy.moneyallaround.domain.trade.dto.request.TradeListRequestDto;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.repository.TradeRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class TradeService {
    private final TradeRepository tradeRepository;
    private final MemberService memberService;
    private final TradeImageService tradeImageService;
    private final KeywordNotificationService keywordNotificationService;

    public Slice<Trade> findAll(TradeListRequestDto tradeListRequestDto, Pageable pageable) {
        return tradeRepository.findAll(tradeListRequestDto, pageable);
    }

    public Slice<Trade> findCompleteTradeSellHistory(Long sellerId, Long lastTradeId, Pageable pageable) {
        return tradeRepository.findCompleteTradeBySeller(memberService.findById(sellerId), lastTradeId, pageable);
    }

    public Slice<Trade> findSaleTradeSellHistory(Long sellerId, Long lastTradeId, Pageable pageable) {
        return tradeRepository.findSaleTradeBySeller(memberService.findById(sellerId), lastTradeId, pageable);
    }

    public Slice<Trade> findTradeBuyHistory(Long buyerId, Long lastTradeId, Pageable pageable) {
        return tradeRepository.findByBuyerAndStatus(memberService.findById(buyerId), lastTradeId, pageable);
    }

    public Slice<Trade> findLikeTrade(Long memberId, Long lastTradeId, Pageable pageable) {
        return tradeRepository.findLikeTradeByMember(memberService.findById(memberId), lastTradeId, pageable);
    }

    public Trade findTrade(Long tradeId) {
        return tradeRepository.findById(tradeId).orElseThrow(EntityNotFoundException::new);
    }

    @Transactional
    public Trade createTrade(TradeRequestDto tradeCreateRequestDto, Long memberId) {
        Trade trade =  tradeRepository.save(tradeCreateRequestDto.toTrade(memberService.findById(memberId)));
        tradeImageService.createTradeImageList(tradeCreateRequestDto.imageUrlList(), trade);
        createKeywordNotificationByTrade(trade);
        return findTrade(trade.getId());
    }

    @Transactional
    public Trade updateTrade(Long tradeId, TradeRequestDto tradeRequestDto) {
        tradeRepository.findById(tradeId)
                .ifPresentOrElse(trade -> {
                            tradeImageService.deleteTradeImageByTradeId(tradeId);
                            tradeImageService.createTradeImageList(tradeRequestDto.imageUrlList(), trade);
                            trade.update(tradeRequestDto.title(), tradeRequestDto.description(), tradeRequestDto.thumbnailImageUrl(), tradeRequestDto.countryCode(), tradeRequestDto.foreignCurrencyAmount(), tradeRequestDto.koreanWonAmount(), tradeRequestDto.latitude(), tradeRequestDto.longitude(), tradeRequestDto.preferredTradeCountry(), tradeRequestDto.preferredTradeCity(), tradeRequestDto.preferredTradeDistrict(), tradeRequestDto.preferredTradeTown());
                        },
                        () -> { throw new EntityNotFoundException(); });

        return findTrade(tradeId);
    }

    @Transactional
    public void deleteTrade(Long tradeId) {
        tradeRepository.findById(tradeId)
                .ifPresentOrElse(trade -> {
                            tradeImageService.deleteTradeImageByTradeId(tradeId);
                            trade.delete();
                        },
                        () -> { throw new EntityNotFoundException(); });
    }

    @Transactional
    public Trade makePromise(Long tradeId, PromiseCreateRequestDto promiseCreateRequestDto) {
        tradeRepository.findById(tradeId)
                .ifPresentOrElse(trade -> trade.makePromise(memberService.findById(promiseCreateRequestDto.buyerId()), promiseCreateRequestDto.type(), promiseCreateRequestDto.directTradeTime(), promiseCreateRequestDto.directTradeLocationDetail()),
                        () -> { throw new EntityNotFoundException(); });

        return findTrade(tradeId);
    }

    @Transactional
    public Trade updatePromise(Long tradeId, PromiseUpdateRequestDto promiseUpdateRequestDto) {
        tradeRepository.findById(tradeId)
                .ifPresentOrElse(trade -> trade.updatePromise(promiseUpdateRequestDto.type(), promiseUpdateRequestDto.directTradeTime(), promiseUpdateRequestDto.directTradeLocationDetail()),
                        () -> { throw new EntityNotFoundException(); });

        return findTrade(tradeId);
    }

    @Transactional
    public Trade cancelPromise(Long tradeId) {
        tradeRepository.findById(tradeId)
                .ifPresentOrElse(Trade::cancelPromise,
                        () -> { throw new EntityNotFoundException(); });

        return findTrade(tradeId);
    }

    @Transactional
    public Trade completePromise(Long tradeId) {
        tradeRepository.findById(tradeId)
                .ifPresentOrElse(Trade::complete,
                        () -> { throw new EntityNotFoundException(); });

        return findTrade(tradeId);
    }

    public void createKeywordNotificationByTrade(Trade trade) {
        keywordNotificationService.createKeywordNotification(trade);
    }
}
