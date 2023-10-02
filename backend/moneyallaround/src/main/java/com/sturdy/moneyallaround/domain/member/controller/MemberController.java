package com.sturdy.moneyallaround.domain.member.controller;

import com.google.api.client.auth.oauth2.TokenRequest;
import com.sturdy.moneyallaround.common.ApiResponse;
import com.sturdy.moneyallaround.domain.member.dto.request.*;
import com.sturdy.moneyallaround.domain.member.dto.response.LogInResponse;
import com.sturdy.moneyallaround.domain.member.service.MemberService;
import com.sturdy.moneyallaround.domain.member.service.RefreshTokenService;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@Slf4j
@Tag(name = "Member API")
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/member")
public class MemberController {
    private final MemberService memberService;
    private final RefreshTokenService refreshTokenService;

    //안드로이드 앱으로부터 Firebase 토큰 수신 및 검증
//    @PostMapping("api/member/verifyFirebaseToken")
//    public ResponseEntity<ApiResponse> verifyFirebaseToken(@RequestBody TokenRequest request) {
//        try {
//            // 1. 클라이언트에서 전달된 Firebase 토큰 검증
//            String firebaseToken = request.getToken;
//            String phoneNumber = String.valueOf(memberService.verifyFirebaseToken(firebaseToken));
//
//            // 2. Firebase 토큰 검증에 성공하면 사용자 정보를 기반으로 JWT 토큰 발급
//            String phoneNumber = memberService.extractPhoneNumberFromToken(firebaseToken);
//            String jwtToken = memberService.createAccessToken(phoneNumber);
//
//            // 3. JWT 토큰을 클라이언트에 응답으로 반환
//            ApiResponse response = ApiResponse.success(jwtToken);
//            return ResponseEntity.ok(response);
//        } catch (ExpiredJwtException ex) {
//            // 4. 토큰 만료 처리
//            ApiResponse response = ApiResponse.error("Token expired");
//            return ResponseEntity.badRequest().body(response);
//        } catch (Exception ex) {
//            // 5. 다른 예외 처리
//            ApiResponse response = ApiResponse.error("Token verification failed");
//            return ResponseEntity.badRequest().body(response);
//        }
//    }


    @Operation(summary = "닉네임 중복확인", description = "닉네임 중복을 확인한다.")
    @ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "성공"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "인증 실패"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "사용자 없음"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 오류")
    })

    @PostMapping("/api/member/check/nickname")
    public ApiResponse checkNickname(@RequestBody CheckNicknameRequest request){
        log.info("닉네임 전송 시작");
        return ApiResponse.success(memberService.checkNickname(request));
    }

    @Operation(summary = "전화벊 중복 확인", description = "전화번호 중복을 확인한다.")
    @ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "성공"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "인증 실패"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "사용자 없음"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 오류")
    })

    @PostMapping("/api/member/check/tel")
    public ApiResponse checkTel(@RequestBody CheckTelnumberRequest request ){
        log.info("전화번호 전송 시작");
        return ApiResponse.success(memberService.checkTel(request));
    }


    @Operation(summary = "회원가입", description = "전화번호 인증을 통해 회원가입 한다.")
    @ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "성공"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "인증 실패"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "사용자 없음"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 오류")
    })


    @PostMapping("/api/member/join")
    public ApiResponse signUp(@RequestBody SignUpRequest request) {
        log.info("회원가입 시작");
        return ApiResponse.success(memberService.registNewMember(request));
    }


    @Operation(summary = "로그인", description = "전화번호 인증을 통해 로그인한다")
    @ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "성공"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "인증 실패"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "사용자 없음"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @PostMapping("/api/member/login")
    public ApiResponse logIn(@RequestBody LogInRequest request){
        log.info("로그인 시작");
        LogInResponse logInResponse = memberService.logIn(request);
    }


    @Operation(summary = "로그아웃", description = "로그아웃")
    @ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "성공"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "인증 실패"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "사용자 없음"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @PostMapping("/api/member/logout")
    public ApiResponse logout (@RequestBody LogoutRequest reqeust){
        log.info("로그아웃 시작");
        log.info("refreshToken={}", reqeust.refreshToken());
        refreshTokenService.delValues(reqeust.refreshToken()); // Redis에 저장된 refreshToken 삭제
        return ApiResponse.success("SUCCESS");
    }

    @Operation(summary = "회원 정보 삭제", description = "회원 정보를 삭제한다.")
    @ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "성공"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "인증 실패"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "사용자 없음"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @DeleteMapping("/api/member/delete")
    public ApiResponse deleteMember (UserDetails principal){
        String memberId =  principal.getUsername();
        return ApiResponse.success(memberService.deleteMember(memberId));
    }



}









