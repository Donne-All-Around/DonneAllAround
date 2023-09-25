package com.sturdy.moneyallaround.member.dto.response;

import com.sturdy.moneyallaround.member.entity.Member;

public record SignUpResponse(
        String tel) {


    public static SignUpResponse from(Member member){
        return new SignUpResponse(
                member.getTel()
        );
    }

}
