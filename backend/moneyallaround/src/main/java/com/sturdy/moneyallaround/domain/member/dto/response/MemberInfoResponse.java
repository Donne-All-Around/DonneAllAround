package com.sturdy.moneyallaround.domain.member.dto.response;

import com.sturdy.moneyallaround.domain.member.entity.Member;
import lombok.Builder;

@Builder
public record MemberInfoResponse(Long id,
                                 String nickname,
                                 String imageUrl,
                                 int point,
                                 int rating,
                                 String tel,
                                 String uid) {
    public static MemberInfoResponse from(Member member) {
        return MemberInfoResponse.builder()
                .id(member.getId())
                .nickname(member.getNickname())
                .imageUrl(member.getImageUrl())
                .point(member.getPoint())
                .rating(member.getRating())
                .tel(member.getTel())
                .uid(member.getUid())
                .build();
    }
}
