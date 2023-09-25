package com.sturdy.moneyallaround.domain.trade.controller;

import com.sturdy.moneyallaround.common.api.ApiResponse;
import com.sturdy.moneyallaround.domain.trade.dto.request.TradeReviewRequestDto;
import com.sturdy.moneyallaround.domain.trade.dto.response.TradeReviewResponseDto;
import com.sturdy.moneyallaround.domain.trade.entity.TradeReview;
import com.sturdy.moneyallaround.domain.trade.service.TradeReviewService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/trade/review")
@RequiredArgsConstructor
public class TradeReviewController {
    private final TradeReviewService tradeReviewService;

    @PostMapping("/{tradeId}")
    public ApiResponse<Object> createTradeReview(@PathVariable Long tradeId, @RequestBody TradeReviewRequestDto tradeReviewRequestDto) {
        Long reviewerId = 1L;
        tradeReviewService.createTradeReview(tradeId, reviewerId, tradeReviewRequestDto);
        return ApiResponse.success("거래 후기 등록 성공", null);
    }

    @GetMapping
    public ApiResponse<Map<String, Object>> tradeReviewList(@RequestParam Long lastTradeReviewId, @PageableDefault(size = 20, sort = "createTime", direction = Sort.Direction.DESC)Pageable pageable) {
        Long revieweeId = 1L;
        Slice<TradeReview> slices = tradeReviewService.findTradeReview(revieweeId, lastTradeReviewId, pageable);
        Map<String, Object> response = new HashMap<>();
        response.put("tradeReviewList", slices.stream().map(TradeReviewResponseDto::from).toList());
        response.put("last", slices.isLast());
        return ApiResponse.success("나의 후기 목록 조회 성공", response);
    }

    @GetMapping("/score")
    public ApiResponse<Map<String, Integer>> tradeReviewScoreList() {
        Long revieweeId = 1L;
        return ApiResponse.success("나의 후기 항목별 개수 조회 성공", tradeReviewService.countScore(revieweeId));
    }
}
