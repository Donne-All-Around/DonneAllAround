package com.sturdy.moneyallaround.domain.member.dto.request;

public record UpdateTelRequest(

        //기존 전화번호
        String telOrigin,

        // 변경 전화번호
        String telNew
) {
}
