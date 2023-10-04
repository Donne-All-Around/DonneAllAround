package com.sturdy.moneyallaround.domain.member.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

public record ReIssueResponse(
        String accessToken,
        @Schema(description="ReIssue Status Message", example = "INVALID_REFRESH_TOKEN")
        String message
) {
        public static ReIssueResponse from(String accessToken, String message){
               return new ReIssueResponse(
                       accessToken,
                       message
               );
        }
}
