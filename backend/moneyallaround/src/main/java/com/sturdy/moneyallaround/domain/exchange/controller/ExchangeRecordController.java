package com.sturdy.moneyallaround.domain.exchange.controller;

import com.sturdy.moneyallaround.common.api.ApiResponse;
import com.sturdy.moneyallaround.domain.exchange.dto.request.ExchangeRecordRequestDto;
import com.sturdy.moneyallaround.domain.exchange.dto.response.ExchangeRecordResponseDto;
import com.sturdy.moneyallaround.domain.exchange.entity.ExchangeRecord;
import com.sturdy.moneyallaround.domain.exchange.service.ExchangeRecordService;
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
@RequestMapping("/api/exchange/record")
@RequiredArgsConstructor
public class ExchangeRecordController {
    private final ExchangeRecordService exchangeRecordService;

    @GetMapping("/list")
    public ApiResponse<Map<String, Object>> exchangeRecordList(
            @RequestParam(required = false) Long lastExchangeRecordId,
            @AuthenticationPrincipal UserDetails principal,
            @PageableDefault(size = 20, sort = "exchangeDate", direction = Sort.Direction.DESC)Pageable pageable) {
        Slice<ExchangeRecord> slices = exchangeRecordService.findByMember(principal.getUsername(), lastExchangeRecordId, pageable);
        Map<String, Object> response = new HashMap<>();
        response.put("exchangeRecordList", slices.stream().map(ExchangeRecordResponseDto::from).toList());
        response.put("last", slices.isLast());
        return ApiResponse.success("환전 기록 조회 성공", response);
    }

    @PostMapping("/create")
    public ApiResponse<ExchangeRecordResponseDto> createExchangeRecord(
            @AuthenticationPrincipal UserDetails principal,
            @RequestBody ExchangeRecordRequestDto exchangeRecordRequestDto) {
        return ApiResponse.success("환전 기록 작성 성공", ExchangeRecordResponseDto.from(exchangeRecordService.createExchangeRecord(exchangeRecordRequestDto, principal.getUsername())));
    }

    @DeleteMapping("/{exchangeRecordId}")
    public ApiResponse<Object> deleteExchangeRecord(
            @PathVariable Long exchangeRecordId) {
        exchangeRecordService.deleteExchangeRecord(exchangeRecordId);
        return ApiResponse.success("환전 기록 삭제 성공", null);
    }

    @PutMapping("/{exchangeRecordId}")
    public ApiResponse<ExchangeRecordResponseDto> updateExchangeRecord(
            @PathVariable Long exchangeRecordId,
            @RequestBody ExchangeRecordRequestDto exchangeRecordRequestDto) {
        return ApiResponse.success("환전 기록 수정 성공", ExchangeRecordResponseDto.from(exchangeRecordService.updateExchangeRecord(exchangeRecordRequestDto, exchangeRecordId)));
    }
}
