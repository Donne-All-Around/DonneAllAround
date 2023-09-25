package com.sturdy.moneyallaround.domain.member.dto.response;

import com.sturdy.moneyallaround.domain.member.entity.Member;

public record UpdateProfileResponse(
        String nickname,
        String imageUrl

        //String tel
) {

    public static UpdateProfileResponse from(Member member){
        return new UpdateProfileResponse(
                member.getNickname(),
                member.getImageUrl()
               // member.getTel()
        );

    }
}
