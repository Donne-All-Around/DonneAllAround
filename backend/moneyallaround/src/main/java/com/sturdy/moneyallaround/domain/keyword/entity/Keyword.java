package com.sturdy.moneyallaround.domain.keyword.entity;

import com.sturdy.moneyallaround.common.audit.BaseEntity;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Keyword extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Long id;

    @Column(nullable = false)
    private String countryCode;

    @Column(nullable = false)
    private String preferredTradeCountry;
    @Column(nullable = false)
    private String preferredTradeCity;
    @Column(nullable = false)
    private String preferredTradeDistrict;
    @Column(nullable = false)
    private String preferredTradeTown;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;
}
