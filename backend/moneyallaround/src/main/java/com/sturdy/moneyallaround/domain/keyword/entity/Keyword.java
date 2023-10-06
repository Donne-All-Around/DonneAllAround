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
    private String country;
    @Column(nullable = true)
    private String administrativeArea;
    @Column(nullable = true)
    private String subAdministrativeArea;
    @Column(nullable = true)
    private String locality;
    @Column(nullable = true)
    private String subLocality;
    @Column(nullable = true)
    private String thoroughfare;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @Builder
    public Keyword(String countryCode, String country, String administrativeArea, String subAdministrativeArea, String locality, String subLocality, String thoroughfare, Member member) {
        this.countryCode = countryCode;
        this.country = country;
        this.administrativeArea = administrativeArea;
        this.subAdministrativeArea = subAdministrativeArea;
        this.locality = locality;
        this.subLocality = subLocality;
        this.thoroughfare = thoroughfare;
        this.member = member;
    }
}
