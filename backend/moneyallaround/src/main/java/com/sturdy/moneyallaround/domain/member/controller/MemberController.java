package com.sturdy.moneyallaround.domain.member.controller;

import com.sturdy.moneyallaround.common.api.ApiResponse;
import com.sturdy.moneyallaround.domain.member.dto.request.*;
import com.sturdy.moneyallaround.domain.member.dto.response.*;
import com.sturdy.moneyallaround.domain.member.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/member")
public class MemberController {
    private final MemberService memberService;

    @PostMapping("/check/nickname")
    public ApiResponse<CheckNicknameResponse> checkNickname(@RequestBody CheckNicknameRequest request){
        return ApiResponse.success("닉네임 중복 체크 성공", memberService.checkNickname(request));
    }

    @PostMapping("/check/tel")
    public ApiResponse<CheckTelResponse> checkTel(@RequestBody CheckTelnumberRequest request){
        return ApiResponse.success("전화번호 중복 체크 성공", memberService.checkTel(request));
    }

    @PostMapping("/sign-in")
    public FirebaseAuthResponse firebaseToken(@RequestBody FirebaseAuthRequest firebaseAuthRequest) {
        return memberService.signIn(firebaseAuthRequest);
    }

    @PostMapping("/join")
    public ApiResponse<SignUpResponse> signUp(@RequestBody SignUpRequest signUpRequest) {
        return ApiResponse.success("회원 가입 성공", memberService.signUp(signUpRequest));
    }

    @PostMapping("/logout")
    public ApiResponse<Object> logout(@RequestBody LogoutRequest logoutRequest, @AuthenticationPrincipal UserDetails principal) {
        memberService.logout(logoutRequest, principal.getUsername());
        return ApiResponse.success("로그아웃 성공", null);
    }

    @PutMapping("/update")
    public ApiResponse<UpdateProfileResponse> updateMember (@RequestBody UpdateProfileRequest request, @AuthenticationPrincipal UserDetails principal){
        return ApiResponse.success("회원 정보 수정 성공", memberService.updateProfile(request, principal.getUsername()));
    }

    @PostMapping("/delete")
    public ApiResponse<Object> deleteMember(@RequestBody LogoutRequest request, @AuthenticationPrincipal  UserDetails principal) {
        memberService.deleteMember(request, principal.getUsername());
        return ApiResponse.success("회원 탈퇴 성공", null);
    }

    @GetMapping("/info")
    public ApiResponse<MemberInfoResponse> info(@AuthenticationPrincipal UserDetails principal) {
        return ApiResponse.success("회원 정보 조회 성공", MemberInfoResponse.from(memberService.findByTel(principal.getUsername())));
    }

    @PostMapping("/reissue")
    public ApiResponse<ReIssueResponse> reissue(@RequestBody ReIssueRequest request) {
        return ApiResponse.success("토큰 재발급 성공", memberService.reissue(request.refreshToken(), SecurityContextHolder.getContext().getAuthentication()));
    }
}