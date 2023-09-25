package com.sturdy.moneyallaround.domain.keyword.controller;

import com.sturdy.moneyallaround.common.api.ApiResponse;
import com.sturdy.moneyallaround.domain.keyword.dto.request.KeywordRequestDto;
import com.sturdy.moneyallaround.domain.keyword.dto.response.KeywordResponseDto;
import com.sturdy.moneyallaround.domain.keyword.service.KeywordService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/keyword")
@RequiredArgsConstructor
public class KeywordController {
    private final KeywordService keywordService;

    @PostMapping
    public ApiResponse<Object> createKeyword(@RequestBody KeywordRequestDto keywordRequestDto) {
        Long memberId = 1L;

        if (keywordService.existKeyword(keywordRequestDto, memberId)) {
            return ApiResponse.fail("이미 존재하는 키워드");
        }

        keywordService.createKeyword(keywordRequestDto, memberId);
        return ApiResponse.success("키워드 등록 성공", null);
    }

    @DeleteMapping("/{keywordId}")
    public ApiResponse<Object> deleteKeyword(@PathVariable Long keywordId) {
        keywordService.deleteKeyword(keywordId);
        return ApiResponse.success("키워드 삭제 성공", null);
    }

    @GetMapping
    public ApiResponse<List<KeywordResponseDto>> keywordList() {
        Long memberId = 1L;
        return ApiResponse.success("키워드 목록 조회 성공", keywordService.findAll(memberId).stream().map(KeywordResponseDto::from).toList());
    }
}
