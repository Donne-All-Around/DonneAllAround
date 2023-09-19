package com.sturdy.moneyallaround.member.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

public record ReIssueResponse(

        String accessToken,

        @Schema(description="ReIssue Status Message", example = "INVALID_REFRESH_TOKEN")
        String message
) {
    // 리프레스 토큰을 사용해 새로운 엑세스 토큰 요청하고 서버에서 응답으로
    // ReIssue리스폰스 객체 반환하면 accessToken 필드를 통해 새로운 토큰 받고, 메세지 필드로 재발급 상태를 확인 가능하다
        public static ReIssueResponse from(String accessToken, String message){
               return new ReIssueResponse(
                       accessToken,
                       message
               );
        }


}
