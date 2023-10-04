package com.sturdy.moneyallaround.domain.member.controller;

import com.sturdy.moneyallaround.common.ApiResponse;
import com.sturdy.moneyallaround.domain.member.dto.request.*;
import com.sturdy.moneyallaround.domain.member.dto.response.FirebaseAuthResponse;
import com.sturdy.moneyallaround.domain.member.dto.response.SignUpResponse;
import com.sturdy.moneyallaround.domain.member.service.MemberService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
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

    @PostMapping("/check/nickname")
    public ApiResponse checkNickname(@RequestBody CheckNicknameRequest request){
        log.info("닉네임 중복 체크");
        return ApiResponse.success(memberService.checkNickname(request));
    }

    @PostMapping("/check/tel")
    public ApiResponse checkTel(@RequestBody CheckTelnumberRequest request){
        log.info("전화번호 중복 체크");
        return ApiResponse.success(memberService.checkTel(request));
    }

    @PostMapping("/sign-in")
    public FirebaseAuthResponse firebaseToken(@RequestBody FirebaseAuthRequest firebaseAuthRequest) {
        log.info("로그인");
        return memberService.signIn(firebaseAuthRequest);
    }

    @PostMapping("/join")
    public SignUpResponse signUp(@RequestBody SignUpRequest signUpRequest) {
        log.info("회원가입");
        return memberService.signUp(signUpRequest);
    }

    @PostMapping("/logout")
    public ApiResponse logout(@RequestBody LogoutRequest logoutRequest, @AuthenticationPrincipal UserDetails principal) {
        log.info("로그아웃");
        String memberTel = principal.getUsername();
        memberService.logout(logoutRequest, memberTel);
        return ApiResponse.success("SUCCESS");
    }

    @PutMapping("/update")
    public ApiResponse updateMember (@RequestBody UpdateProfileRequest request, @AuthenticationPrincipal UserDetails principal){
        log.info("회원 정보 수정 - 닉네임 및 프로필 이미지");
        String memberTel = principal.getUsername();
        return ApiResponse.success(memberService.updateProfile(request, memberTel));
    }

    @PutMapping("/delete")
    public ApiResponse deleteMember(@RequestBody LogoutRequest request, @AuthenticationPrincipal  UserDetails principal) {
        log.info("회원 탈퇴");
        String memberTel = principal.getUsername();
        return ApiResponse.success(memberService.deleteMember(request, memberTel));
    }

    @GetMapping("/info")
    public ApiResponse info(@AuthenticationPrincipal UserDetails principal) {
        log.info("회원 정보 조회");
        String memberTel = principal.getUsername();
        return ApiResponse.success(memberService.findByTel(memberTel));
    }

    @GetMapping("/reissue")
    public ApiResponse reissue(@RequestBody LogoutRequest request) {
        log.info("토크 재발급");
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return ApiResponse.success(memberService.reissue(request.refreshToken(), authentication));
    }
}









