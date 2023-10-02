package com.sturdy.moneyallaround.domain.transfer.controller;

import com.sturdy.moneyallaround.common.api.ApiResponse;
import com.sturdy.moneyallaround.domain.transfer.dto.request.TransferRequestDto;
import com.sturdy.moneyallaround.domain.transfer.service.TransferService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/transfer")
@RequiredArgsConstructor
public class TransferController {
    private final TransferService transferService;

    @PostMapping
    public ApiResponse<Object> transfer(
            @RequestParam(required = false) Long memberId,
            @RequestBody TransferRequestDto transferRequestDto
            ) {
        transferService.transfer(memberId, transferRequestDto);
        return ApiResponse.success("송금 성공", null);
    }

    @DeleteMapping("/{tradeId}")
    public ApiResponse<Object> cancelTransfer(
            @PathVariable Long tradeId
           ) {
        transferService.cancelTransfer(tradeId);
        return ApiResponse.success("송금 취소 성공", null);
    }

    @DeleteMapping("/{tradeId}/deposit")
    public ApiResponse<Object> deposit(
            @PathVariable Long tradeId
    ) {
        transferService.deposit(tradeId);
        return ApiResponse.success("판매자에게 이체 성공", null);
    }
}

