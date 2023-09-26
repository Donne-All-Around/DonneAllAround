package com.sturdy.moneyallaround.domain.member.dto.request;

public record UpdateProfileRequest(

        String nickname,
        String imageUrl
) {
}
