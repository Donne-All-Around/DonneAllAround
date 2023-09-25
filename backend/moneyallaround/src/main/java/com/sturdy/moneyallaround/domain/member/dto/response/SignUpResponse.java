package com.sturdy.moneyallaround.domain.member.dto.response;

import com.sturdy.moneyallaround.domain.member.entity.Member;

public record SignUpResponse(
        String tel) {


    public static SignUpResponse from(Member member){
        return new SignUpResponse(
                member.getTel()
        );
    }

}
