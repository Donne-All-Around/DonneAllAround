package com.sturdy.moneyallaround.domain.trade.controller;

import com.sturdy.moneyallaround.common.api.ApiResponse;
import com.sturdy.moneyallaround.domain.trade.dto.request.TradeCreateRequestDto;
import com.sturdy.moneyallaround.domain.trade.dto.request.TradeListRequestDto;
import com.sturdy.moneyallaround.domain.trade.dto.response.TradeCreateResponseDto;
import com.sturdy.moneyallaround.domain.trade.dto.response.TradeHistoryResponseDto;
import com.sturdy.moneyallaround.domain.trade.dto.response.TradeInfoResponseDto;
import com.sturdy.moneyallaround.domain.trade.dto.response.TradeSimpleResponseDto;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.service.TradeImageService;
import com.sturdy.moneyallaround.domain.trade.service.TradeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Slf4j
@RestController
@RequestMapping("/api/trade")
@RequiredArgsConstructor
public class TradeController {
    private final TradeService tradeService;
    private final TradeImageService tradeImageService;

    /*
        거래 글 목록 (최신순 / 낮은 가격순 / 낮은 가격순(단위))
        - 거래 통화
        - 거래 장소 (국가 / 시 / 구 / 동)
        - 마지막 거래 번호 / 마지막 거래 가격 / 마지막 거래 가격 단위
        - pageable (개수 / 기준 / 순서)
     */
    @PostMapping
    public ApiResponse<Map<String, Object>> tradeList(
            @RequestBody @Valid TradeListRequestDto tradeListRequestDto,
            @PageableDefault(size = 20, sort = "createTime", direction = Sort.Direction.DESC)Pageable pageable) {
        Slice<Trade> slices = tradeService.findAll(tradeListRequestDto, pageable);
        Map<String, Object> response = new HashMap<>();
        response.put("tradeList", slices.stream().map(TradeSimpleResponseDto::from).toList());
        response.put("hasNext", slices.isLast());
        return ApiResponse.success("거래 목록 조회 성공", response);
    }

    // 나의 판매 내역 - 판매중
    @GetMapping("/history/sell/progress")
    public ApiResponse<List<TradeHistoryResponseDto>> progressTradeSellHistoryList(@PageableDefault(size = 20, sort = "createTime", direction = Sort.Direction.DESC)Pageable pageable) {

    }

    // 나의 판매 내역 - 거래 완료

    // 나의 구매 내역

    // 관심 거래 목록



    // 거래 상세 조회

    // 채팅방 내 거래 정보 조회



    // 거래 글 작성

    // 거래 글 수정

    // 거래 글 삭제



    // 약속 잡기

    // 수령하기

//    @PostMapping
//    public ApiResponse<TradeCreateResponseDto> createTrade(@RequestBody @Valid TradeCreateRequestDto tradeCreateRequestDto) {
//        Long sellerId = 1L;
//        Trade trade = tradeService.createTrade(tradeCreateRequestDto, sellerId);
//        tradeImageService.createTradeImage(tradeCreateRequestDto.imageUrlList(), trade);
//        return ApiResponse.success("거래 글 작성 성공", TradeCreateResponseDto.from(trade));
//    }

    @GetMapping("/{tradeId}")
    public ApiResponse<TradeInfoResponseDto> getTradeInfo(@PathVariable Long tradeId) {

        return null;
    }
}
