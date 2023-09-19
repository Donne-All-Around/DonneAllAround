package com.sturdy.moneyallaround.domain.keyword.entity;

import com.sturdy.moneyallaround.common.audit.BaseEntity;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
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

    @Column(nullable = true)
    private String preferredTradeCountry;
    @Column(nullable = true)
    private String preferredTradeCity;
    @Column(nullable = true)
    private String preferredTradeDistrict;
    @Column(nullable = true)
    private String preferredTradeTown;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @Builder
    public Keyword(String countryCode, String preferredTradeCountry, String preferredTradeCity, String preferredTradeDistrict, String preferredTradeTown, Member member) {
        this.countryCode = countryCode;
        this.preferredTradeCountry = preferredTradeCountry;
        this.preferredTradeCity = preferredTradeCity;
        this.preferredTradeDistrict = preferredTradeDistrict;
        this.preferredTradeTown = preferredTradeTown;
        this.member = member;
    }
}
