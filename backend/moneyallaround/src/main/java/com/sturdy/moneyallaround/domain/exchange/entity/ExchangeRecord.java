package com.sturdy.moneyallaround.domain.exchange.entity;

import com.sturdy.moneyallaround.common.audit.BaseEntity;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Getter
@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class ExchangeRecord extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Long id;

    @Column(nullable = false)
    private String countryCode;

    @Column(nullable = false)
    private String bankCode;

    @Column(nullable = false)
    private Integer koreanWonAmount;

    @Column(nullable = false)
    private Integer foreignCurrencyAmount;

    @Column(nullable = false)
    private Float tradingBaseRate;

    @Column(nullable = false)
    private Integer preferentialRate;

    @Column(nullable = false)
    private LocalDate exchangeDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @Builder
    public ExchangeRecord(String countryCode, String bankCode, Integer koreanWonAmount, Integer foreignCurrencyAmount, Float tradingBaseRate, Integer preferentialRate, LocalDate exchangeDate, Member member) {
        this.countryCode = countryCode;
        this.bankCode = bankCode;
        this.koreanWonAmount = koreanWonAmount;
        this.foreignCurrencyAmount = foreignCurrencyAmount;
        this.tradingBaseRate = tradingBaseRate;
        this.preferentialRate = preferentialRate;
        this.exchangeDate = exchangeDate;
        this.member = member;
    }

    public void update(String countryCode, String bankCode, Integer koreanWonAmount, Integer foreignCurrencyAmount, Float tradingBaseRate, Integer preferentialRate, LocalDate exchangeDate) {
        this.countryCode = countryCode;
        this.bankCode = bankCode;
        this.koreanWonAmount = koreanWonAmount;
        this.foreignCurrencyAmount = foreignCurrencyAmount;
        this.tradingBaseRate = tradingBaseRate;
        this.preferentialRate = preferentialRate;
        this.exchangeDate = exchangeDate;
    }
}
