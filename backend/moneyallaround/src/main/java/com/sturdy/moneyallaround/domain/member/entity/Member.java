package com.sturdy.moneyallaround.domain.member.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Member {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Long id;

    @Column(nullable = false, unique = true)
    private String tel;

    @Column(nullable = false)
    private String nickname;

    @Column(nullable = false)
    private Integer point;

    @Column(nullable = false)
    private Integer rating;

    @Column(nullable = false)
    private String imageUrl;

    public void updateRating(int reviewScore) {
        rating = (rating + (rating + reviewScore * 50) * 2) / 3;
    }
}
