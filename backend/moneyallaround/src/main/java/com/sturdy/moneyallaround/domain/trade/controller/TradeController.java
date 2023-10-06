package com.sturdy.moneyallaround.domain.trade.controller;

import com.sturdy.moneyallaround.common.api.ApiResponse;
import com.sturdy.moneyallaround.domain.keyword.service.KeywordNotificationService;
import com.sturdy.moneyallaround.domain.trade.dto.request.*;
import com.sturdy.moneyallaround.domain.trade.dto.response.TradeChatResponseDto;
import com.sturdy.moneyallaround.domain.trade.dto.response.TradeDetailResponseDto;
import com.sturdy.moneyallaround.domain.trade.dto.response.TradeHistoryResponseDto;
import com.sturdy.moneyallaround.domain.trade.dto.response.TradeSimpleResponseDto;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.service.TradeLikeService;
import com.sturdy.moneyallaround.domain.trade.service.TradeReviewService;
import com.sturdy.moneyallaround.domain.trade.service.TradeService;
import com.sturdy.moneyallaround.domain.transfer.service.TransferService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/trade")
@RequiredArgsConstructor
public class TradeController {
    private final TradeService tradeService;
    private final TradeLikeService tradeLikeService;
    private final TradeReviewService tradeReviewService;
    private final KeywordNotificationService keywordNotificationService;
    private final TransferService transferService;

    @PostMapping("/list")
    public ApiResponse<Map<String, Object>> tradeList(
            @RequestParam(required = false) Long lastTradeId,
            @RequestBody @Valid TradeListRequestDto tradeListRequestDto,
            @PageableDefault(size = 20, sort = "createTime", direction = Sort.Direction.DESC)Pageable pageable) {
        Slice<Trade> slices = tradeService.findAll(tradeListRequestDto, lastTradeId, pageable);
        Map<String, Object> response = new HashMap<>();
        response.put("tradeList", slices.stream().map(TradeSimpleResponseDto::from).toList());
        response.put("last", slices.isLast());
        return ApiResponse.success("거래 목록 조회 성공", response);
    }

    @GetMapping("/history/sell/complete")
    public ApiResponse<Map<String, Object>> completeTradeSellHistoryList(
            @RequestParam(required = false) Long lastTradeId,
            @AuthenticationPrincipal UserDetails principal,
            @PageableDefault(size = 20, sort = "createTime", direction = Sort.Direction.DESC)Pageable pageable) {
        String memberTel = principal.getUsername();
        Slice<Trade> slices = tradeService.findCompleteTradeSellHistory(memberTel, lastTradeId, pageable);
        Map<String, Object> response = new HashMap<>();
        response.put("tradeList", slices.stream().map(trade -> TradeHistoryResponseDto.from(trade, tradeReviewService.existTradeReview(trade.getId(), memberTel))).toList());
        response.put("last", slices.isLast());
        return ApiResponse.success("판매 내역 - 거래 완료 조회 성공", response);
    }

    @GetMapping("/history/sell/sale")
    public ApiResponse<Map<String, Object>> saleTradeSellHistoryList(
            @RequestParam(required = false) Long lastTradeId,
            @AuthenticationPrincipal UserDetails principal,
            @PageableDefault(size = 20, sort = "createTime", direction = Sort.Direction.DESC)Pageable pageable) {
        String memberTel = principal.getUsername();
        Slice<Trade> slices = tradeService.findSaleTradeSellHistory(memberTel, lastTradeId, pageable);
        Map<String, Object> response = new HashMap<>();
        response.put("tradeList", slices.stream().map(trade -> TradeHistoryResponseDto.from(trade, tradeReviewService.existTradeReview(trade.getId(), memberTel))).toList());
        response.put("last", slices.isLast());
        return ApiResponse.success("판매 내역 - 판매 중 조회 성공", response);
    }

    @GetMapping("/history/buy")
    public ApiResponse<Map<String, Object>> tradeBuyHistoryList(
            @RequestParam(required = false) Long lastTradeId,
            @AuthenticationPrincipal UserDetails principal,
            @PageableDefault(size = 20, sort = "createTime", direction = Sort.Direction.DESC)Pageable pageable) {
        String memberTel = principal.getUsername();
        Slice<Trade> slices = tradeService.findTradeBuyHistory(memberTel, lastTradeId, pageable);
        Map<String, Object> response = new HashMap<>();
        response.put("tradeList", slices.stream().map(trade -> TradeHistoryResponseDto.from(trade, tradeReviewService.existTradeReview(trade.getId(), memberTel))).toList());
        response.put("last", slices.isLast());
        return ApiResponse.success("구매 내역 조회 성공", response);
    }

    @GetMapping("/like")
    public ApiResponse<Map<String, Object>> tradeLikeList(
            @RequestParam(required = false) Long lastTradeId,
            @AuthenticationPrincipal UserDetails principal,
            @PageableDefault(size = 20, sort = "createTime", direction = Sort.Direction.DESC)Pageable pageable) {
        Slice<Trade> slices = tradeService.findLikeTrade(principal.getUsername(), lastTradeId, pageable);
        Map<String, Object> response = new HashMap<>();
        response.put("tradeList", slices.stream().map(TradeSimpleResponseDto::from).toList());
        response.put("last", slices.isLast());
        return ApiResponse.success("관심 목록 조회 성공", response);
    }

    @GetMapping("/detail/{tradeId}")
    public ApiResponse<TradeDetailResponseDto> tradeDetail(
            @AuthenticationPrincipal UserDetails principal,
            @PathVariable Long tradeId) {
        return ApiResponse.success("거래 상세 조회 성공",
                TradeDetailResponseDto.from(tradeService.findTrade(tradeId), tradeLikeService.existTradeLike(tradeId, principal.getUsername())));
    }

    @GetMapping("/chat/{tradeId}")
    public ApiResponse<TradeChatResponseDto> tradeChat(
            @AuthenticationPrincipal UserDetails principal,
            @PathVariable Long tradeId) {
        return ApiResponse.success("채팅방 내 거래 정보 조회 성공",
                TradeChatResponseDto.from(tradeService.findTrade(tradeId), tradeReviewService.existTradeReview(tradeId, principal.getUsername()), transferService.existsTransfer(tradeId)));
    }

    @PostMapping("/create")
    public ApiResponse<TradeDetailResponseDto> createTrade(
            @AuthenticationPrincipal UserDetails principal,
            @RequestBody TradeRequestDto tradeRequestDto) {
        String memberTel = principal.getUsername();
        Trade trade = tradeService.createTrade(tradeRequestDto, memberTel);
        keywordNotificationService.createKeywordNotification(trade);
        return ApiResponse.success("거래 글 작성 성공", TradeDetailResponseDto.from(trade, tradeLikeService.existTradeLike(trade.getId(), memberTel)));
    }

    @PutMapping("/edit/{tradeId}")
    public ApiResponse<TradeDetailResponseDto> updateTrade(
            @PathVariable Long tradeId,
            @AuthenticationPrincipal UserDetails principal,
            @RequestBody TradeRequestDto tradeRequestDto) {
        return ApiResponse.success("거래 글 수정 성공",
                TradeDetailResponseDto.from(tradeService.updateTrade(tradeId, tradeRequestDto), tradeLikeService.existTradeLike(tradeId, principal.getUsername())));
    }

   @PutMapping("/delete/{tradeId}")
   public ApiResponse<Object> deleteTrade(
           @PathVariable Long tradeId) {
        tradeService.deleteTrade(tradeId);
        return ApiResponse.success("거래 글 삭제 성공", null);
   }

    @PutMapping("/promise/direct/{tradeId}")
    public ApiResponse<TradeChatResponseDto> makeDirectPromise(
            @PathVariable Long tradeId,
            @AuthenticationPrincipal UserDetails principal,
            @RequestBody PromiseRequestDto promiseRequestDto) {
        return ApiResponse.success("직거래 약속 잡기 성공",
                TradeChatResponseDto.from(tradeService.makeDirectPromise(tradeId, promiseRequestDto), tradeReviewService.existTradeReview(tradeId, principal.getUsername()), transferService.existsTransfer(tradeId)));
    }

    @PutMapping("/promise/delivery/{tradeId}")
    public ApiResponse<TradeChatResponseDto> makeDeliveryPromise(
            @PathVariable Long tradeId,
            @AuthenticationPrincipal UserDetails principal,
            @RequestBody PromiseRequestDto promiseRequestDto) {
        return ApiResponse.success("택배거래 약속 잡기 성공",
                TradeChatResponseDto.from(tradeService.makeDeliveryPromise(tradeId, promiseRequestDto), tradeReviewService.existTradeReview(tradeId, principal.getUsername()), transferService.existsTransfer(tradeId)));
    }

    @PutMapping("/promise/cancel/{tradeId}")
    public ApiResponse<TradeChatResponseDto> cancelPromise(
            @AuthenticationPrincipal UserDetails principal,
            @PathVariable Long tradeId) {
        return ApiResponse.success("약속 취소 성공",
                TradeChatResponseDto.from(tradeService.cancelPromise(tradeId), tradeReviewService.existTradeReview(tradeId, principal.getUsername()), transferService.existsTransfer(tradeId)));
    }

    @PutMapping("/promise/complete/{tradeId}")
    public ApiResponse<TradeChatResponseDto> completePromise(
            @AuthenticationPrincipal UserDetails principal,
            @PathVariable Long tradeId) {
        return ApiResponse.success("거래 완료 성공",
                TradeChatResponseDto.from(tradeService.completePromise(tradeId), tradeReviewService.existTradeReview(tradeId, principal.getUsername()), transferService.existsTransfer(tradeId)));
    }

    @PostMapping("/{tradeId}/like")
    public ApiResponse<Object> tradeLike(
            @AuthenticationPrincipal UserDetails principal,
            @PathVariable Long tradeId) {
        tradeLikeService.like(tradeId, principal.getUsername());
        return ApiResponse.success("관심 거래 등록 성공", null);
    }

    @DeleteMapping("/{tradeId}/unlike")
    public ApiResponse<TradeDetailResponseDto> tradeUnlike(
            @AuthenticationPrincipal UserDetails principal,
            @PathVariable Long tradeId) {
        tradeLikeService.unlike(tradeId, principal.getUsername());
        return ApiResponse.success("관심 거래 취소 성공", null);
    }

    @GetMapping("/search")
    public ApiResponse<Map<String, Object>> search(
            @RequestParam String keyword,
            @RequestParam(required = false) Long lastTradeId,
            @PageableDefault(size = 20, sort = "createTime", direction = Sort.Direction.DESC) Pageable pageable) {
        Slice<Trade> slices = tradeService.search(keyword, lastTradeId, pageable);
        Map<String, Object> response = new HashMap<>();
        response.put("tradeList", slices.stream().map(TradeSimpleResponseDto::from).toList());
        response.put("last", slices.isLast());
        return ApiResponse.success("거래 목록 검색 성공", response);
    }

    @GetMapping("/notification")
    public ApiResponse<Map<String, Object>> notificationList(
            @AuthenticationPrincipal UserDetails principal,
            @RequestParam(required = false) Long lastTradeId,
            @PageableDefault(size = 20, sort = "createTime", direction = Sort.Direction.DESC) Pageable pageable) {
        Slice<Trade> slices = tradeService.findNotification(principal.getUsername(), lastTradeId, pageable);
        Map<String, Object> response = new HashMap<>();
        response.put("tradeList", slices.stream().map(TradeSimpleResponseDto::from).toList());
        response.put("last", slices.isLast());
        return ApiResponse.success("키워드 알림 거래 목록 조회 성공", response);
    }

    @DeleteMapping("/notification/{notificationId}")
    public ApiResponse<Object> deleteNotification(
            @PathVariable Long notificationId) {
        keywordNotificationService.deleteKeywordNotification(notificationId);
        return ApiResponse.success("키워드 알림 거래 삭제 성공", null);
    }
}