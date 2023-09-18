package com.sturdy.moneyallaround.member.controller;

import com.sturdy.moneyallaround.member.dto.request.CheckNicknameRequest;
import com.sturdy.moneyallaround.member.service.MemberService;
import com.sturdy.moneyallaround.member.service.RefreshTokenService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@Tag(name = "Member API")
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/member")
public class MemberController {
    private final MemberService memberService;
    private final RefreshTokenService refreshTokenService;

//    @Operation(summary = "닉네임 중복확인", description = "닉네임 중복을 확인한다.")
//    @ApiResponses({
//            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "성공"),
//            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "인증 실패"),
//            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "사용자 없음"),
//            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 오류")
//    })
//
//    @PostMapping("/checkNickname")
//    public ApiResponses checkNickname(@RequestBody CheckNicknameRequest request){
//        log.info("닉네임 전송 시작");
//        return ApiResponse.success(memberService.checkNickname(request));
//    }

}









