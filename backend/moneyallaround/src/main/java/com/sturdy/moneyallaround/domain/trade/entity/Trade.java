package com.sturdy.moneyallaround.domain.trade.entity;

import com.sturdy.moneyallaround.common.audit.BaseEntity;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@Entity
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Trade extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Long id;

    @Column(nullable = false)
    private String title;
    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false)
    private String thumbnailImageUrl;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TradeStatus status;

    @Column(nullable = false)
    private String countryCode;
    @Column(nullable = false)
    private Integer foreignCurrencyAmount;
    @Column(nullable = false)
    private Integer koreanWonAmount;

    @Column(nullable = false)
    private Double latitude;
    @Column(nullable = false)
    private Double longitude;

    @Column(nullable = false)
    private String preferredTradeCountry;
    @Column(nullable = false)
    private String preferredTradeCity;
    @Column(nullable = false)
    private String preferredTradeDistrict;
    @Column(nullable = false)
    private String preferredTradeTown;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TradeType type;

    @Column(nullable = false)
    private Boolean isShow;

    @Column(nullable = true)
    private LocalDateTime directTradeTime;

    @Column(nullable = true)
    private String directTradeLocationDetail;

    @Column(nullable = false)
    private Boolean isDeliveryReceived;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "seller_id", nullable = false)
    private Member seller;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "buyer_id", nullable = true)
    private Member buyer;

    @OneToMany(mappedBy = "trade", cascade = CascadeType.ALL)
    private List<TradeImage> imageList = new ArrayList<>();

    @OneToMany(mappedBy = "trade", cascade = CascadeType.ALL)
    private List<TradeLike> likeList = new ArrayList<>();

    @Builder
    public Trade(String title, String description, String thumbnailImageUrl, String countryCode, Integer foreignCurrencyAmount, Integer koreanWonAmount, Double latitude, Double longitude, String preferredTradeCountry, String preferredTradeCity, String preferredTradeDistrict, String preferredTradeTown, Member seller) {
        this.title = title;
        this.description = description;
        this.thumbnailImageUrl = thumbnailImageUrl;
        status = TradeStatus.WAIT;
        this.countryCode = countryCode;
        this.foreignCurrencyAmount = foreignCurrencyAmount;
        this.koreanWonAmount = koreanWonAmount;
        this.latitude = latitude;
        this.longitude = longitude;
        this.preferredTradeCountry = preferredTradeCountry;
        this.preferredTradeCity = preferredTradeCity;
        this.preferredTradeDistrict = preferredTradeDistrict;
        this.preferredTradeTown = preferredTradeTown;
        type = TradeType.DIRECT;
        isShow = true;
        isDeliveryReceived = false;
        this.seller = seller;
    }
}
