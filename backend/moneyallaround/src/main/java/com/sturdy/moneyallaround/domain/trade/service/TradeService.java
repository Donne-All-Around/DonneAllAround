package com.sturdy.moneyallaround.domain.trade.service;

import com.sturdy.moneyallaround.domain.keyword.service.KeywordNotificationService;
import com.sturdy.moneyallaround.domain.member.service.MemberService;
import com.sturdy.moneyallaround.domain.trade.dto.request.*;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.entity.TradeImage;
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

    // 완료되지 않은 거래 목록 조회
    public Slice<Trade> findAll(TradeListRequestDto tradeListRequestDto, Pageable pageable) {
        return tradeRepository.findAll(tradeListRequestDto, pageable);
    }

    // 완료된 판매 내역
    public Slice<Trade> findCompleteTradeSellHistory(Long sellerId, Long lastTradeId, Pageable pageable) {
        return tradeRepository.findCompleteTradeBySeller(memberService.findById(sellerId), lastTradeId, pageable);
    }

    // 판매 중인 판매 내역
    public Slice<Trade> findSaleTradeSellHistory(Long sellerId, Long lastTradeId, Pageable pageable) {
        return tradeRepository.findSaleTradeBySeller(memberService.findById(sellerId), lastTradeId, pageable);
    }

    // 구매 내역
    public Slice<Trade> findTradeBuyHistory(Long buyerId, Long lastTradeId, Pageable pageable) {
        return tradeRepository.findByBuyerAndStatus(memberService.findById(buyerId), lastTradeId, pageable);
    }

    // 관심 목록
    public Slice<Trade> findLikeTrade(Long memberId, Long lastTradeId, Pageable pageable) {
        return tradeRepository.findLikeTradeByMember(memberService.findById(memberId), lastTradeId, pageable);
    }

    // 거래 상세 조회
    public Trade findTrade(Long tradeId) {
        return tradeRepository.findById(tradeId).orElseThrow(EntityNotFoundException::new);
    }

    // 거래 글 생성
    @Transactional
    public Trade createTrade(TradeRequestDto tradeRequestDto, Long memberId) {
        Trade trade =  tradeRepository.save(tradeRequestDto.toTrade(memberService.findById(memberId)));
        trade.addImages(tradeRequestDto.imageUrlList().stream().map(imageUrl -> new TradeImage(imageUrl, trade)).toList());
        createKeywordNotificationByTrade(trade);
        return findTrade(trade.getId());
    }

    // 거래 글 수정
    @Transactional
    public Trade updateTrade(Long tradeId, TradeRequestDto tradeRequestDto) {
        tradeRepository.findById(tradeId)
                .ifPresentOrElse(trade -> {
                            tradeImageService.deleteTradeImages(trade.getImageList());
                            trade.getImageList().clear();
                            trade.addImages(tradeRequestDto.imageUrlList().stream().map(imageUrl -> new TradeImage(imageUrl, trade)).toList());
                            trade.update(tradeRequestDto.title(), tradeRequestDto.description(), tradeRequestDto.thumbnailImageUrl(), tradeRequestDto.countryCode(), tradeRequestDto.foreignCurrencyAmount(), tradeRequestDto.koreanWonAmount(), tradeRequestDto.latitude(), tradeRequestDto.longitude(), tradeRequestDto.preferredTradeCountry(), tradeRequestDto.preferredTradeCity(), tradeRequestDto.preferredTradeDistrict(), tradeRequestDto.preferredTradeTown());
                        },
                        () -> { throw new EntityNotFoundException(); });

        return findTrade(tradeId);
    }

    // 거래 글 삭제(isDeleted 속성 수정)
    @Transactional
    public void deleteTrade(Long tradeId) {
        tradeRepository.findById(tradeId)
                .ifPresentOrElse(trade -> {
                            tradeImageService.deleteTradeImages(trade.getImageList());
                            trade.getImageList().clear();
                            trade.delete();
                        },
                        () -> { throw new EntityNotFoundException(); });
    }

    // 직거래 약속 잡기
    @Transactional
    public Trade makeDirectPromise(Long tradeId, DirectTradeCreateRequestDto directTradeCreateRequestDto) {
        tradeRepository.findById(tradeId)
                .ifPresentOrElse(trade -> trade.makeDirectPromise(memberService.findById(directTradeCreateRequestDto.buyerId()), directTradeCreateRequestDto.getDirectTradeTime(), directTradeCreateRequestDto.directTradeLocationDetail()),
                        () -> { throw new EntityNotFoundException(); });

        return findTrade(tradeId);
    }

    // 직거래 약속 수정
    @Transactional
    public Trade updateDirectPromise(Long tradeId, DirectTradeUpdateRequestDto directTradeUpdateRequestDto) {
        tradeRepository.findById(tradeId)
                .ifPresentOrElse(trade -> trade.updateDirectPromise(directTradeUpdateRequestDto.getDirectTradeTime(), directTradeUpdateRequestDto.directTradeLocationDetail()),
                        () -> { throw new EntityNotFoundException(); });

        return findTrade(tradeId);
    }

    // 택배거래 약속 잡기
    @Transactional
    public Trade makeDeliveryPromise(Long tradeId, DeliveryTradeRequestDto deliveryTradeRequestDto) {
        findTrade(tradeId).makeDeliveryPromise(memberService.findById(deliveryTradeRequestDto.buyerId()));
        return findTrade(tradeId);
    }

    // 택배거래 - 판매자 계좌 정보 입력
    @Transactional
    public Trade updateSellerAccountNumber(Long tradeId, AccountNumberRequestDto accountNumberRequestDto) {
        findTrade(tradeId).updateSellerAccountNumber(accountNumberRequestDto.sellerAccountBankCode(), accountNumberRequestDto.sellerAccountNumber());
        return findTrade(tradeId);
    }

    // 택배거래 - 배송지 정보 입력
    @Transactional
    public Trade updateDeliveryInfo(Long tradeId, DeliveryInfoRequestDto deliveryInfoRequestDto) {
        findTrade(tradeId).updateDeliveryInfo(deliveryInfoRequestDto.deliveryRecipientName(), deliveryInfoRequestDto.deliveryRecipientTel(), deliveryInfoRequestDto.deliveryAddressZipCode(), deliveryInfoRequestDto.deliveryAddress(), deliveryInfoRequestDto.deliveryAddressDetail());
        return findTrade(tradeId);
    }

    // 택배거래 - 송장 번호 입력
    @Transactional
    public Trade updateTrackingNumber(Long tradeId, TrackingNumberRequestDto trackingNumberRequestDto) {
        findTrade(tradeId).updateTrackingNumber(trackingNumberRequestDto.trackingNumber());
        return findTrade(tradeId);
    }

    // 약속 취소
    @Transactional
    public Trade cancelPromise(Long tradeId) {
        findTrade(tradeId).cancelPromise();
        return findTrade(tradeId);
    }

    // 거래 완료
    @Transactional
    public Trade completePromise(Long tradeId) {
        findTrade(tradeId).complete();
        return findTrade(tradeId);
    }

    // 새로 등록된 거래 글 기반 키워드 알림 생성
    public void createKeywordNotificationByTrade(Trade trade) {
        keywordNotificationService.createKeywordNotification(trade);
    }

    // 거래 글 검색
    public Slice<Trade> search(String keyword, Long lastTradeId, Pageable pageable) {
        return tradeRepository.findByKeyword(keyword, lastTradeId, pageable);
    }
}
