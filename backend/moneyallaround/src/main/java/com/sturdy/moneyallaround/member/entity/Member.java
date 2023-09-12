package com.sturdy.moneyallaround.member.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.*;

@Getter
@Entity
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class Member {

    @Id
    @Column(name = "id", updatable = false, unique = true, nullable = false)
    private String id;

    @Column(name = "nickname")
    private String nickname;

    @Column(name = "image")
    private String image;



}
