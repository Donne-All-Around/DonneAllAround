package com.sturdy.moneyallaround.domain.member.controller;

import com.sturdy.moneyallaround.Exception.model.FirebaseTokenValidationException;
import com.sturdy.moneyallaround.common.ApiResponse;
import com.sturdy.moneyallaround.config.security.jwt.JwtTokenProvider;
import com.sturdy.moneyallaround.config.security.jwt.TokenInfo;
import com.sturdy.moneyallaround.domain.member.dto.request.*;
import com.sturdy.moneyallaround.domain.member.dto.response.LogInResponse;
import com.sturdy.moneyallaround.domain.member.entity.Member;
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
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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
    private final JwtTokenProvider jwtTokenProvider;


    @PostMapping("/api/member/verifyFirebaseToken") // 파이어베이스 검증
    public ResponseEntity<ApiResponse> login(@RequestBody LogInRequest request, TokenRequest tokenRequest) {
        // SMS 인증 후 Firebase 토큰을 받아온다. (프론트엔드 코드에서 구현)
        String firebaseToken = tokenRequest.firebaseToken();

        // Firebase 토큰을 검증하고, 유효한 사용자인지 확인한다.
        if (!jwtTokenProvider.isValidFirebaseToken(firebaseToken)) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Firebase 토큰 검증 실패"));
        }

        // Firebase 토큰이 유효하면, 해당 사용자를 데이터베이스에서 찾아온다.
        Member member = memberService.findByTel(request.tel());

        // 사용자 정보로 JWT 토큰을 생성한다.
        TokenInfo tokenInfo = jwtTokenProvider.generateToken(request.tel(), firebaseToken, null);

        // JWT 토큰을 응답으로 반환한다.
        return ResponseEntity.ok(ApiResponse.success(tokenInfo));
    }


    @Operation(summary = "sms 인증 로그인", description = "전화번호를 입력하여 sms 인증을 한다.")
    @ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "성공"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "인증 실패"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "사용자 없음"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 오류")
    })

    @PostMapping("/api/member/login") // 로그인 엔드포인트
    public ResponseEntity<ApiResponse> login(@RequestBody LogInRequest request) {
        LogInResponse logInResponse = memberService.logIn(request);
        return ResponseEntity.ok(ApiResponse.success(logInResponse));
    }


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


    @Operation(summary = "전화번호 중복 확인", description = "전화번호 중복을 확인한다.")
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


    @PostMapping("/join")
    public ApiResponse signUp(@RequestBody SignUpRequest request) {
        log.info("회원가입 시작");
        return ApiResponse.success(memberService.registNewMember(request));
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

    //업데이트 부분

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


    //회원 정보 추출

    // 토큰 재발급 부분
    @Operation(summary = "Token 재발급", description = "만료된 Token을 재발급 한다.")
    @ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "성공"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "401", description = "인증 실패"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "사용자 없음"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "서버 오류")
    })
    @GetMapping("/reissue")
    public ApiResponse reissue(@RequestHeader("refreshToken") String refreshToken){
        log.info("토큰 재발급 시작");
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        log.info(authentication.getName());
        return ApiResponse.success(memberService.reissue(refreshToken, authentication));
    }



}









