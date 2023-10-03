package com.sturdy.moneyallaround.domain.trade.entity;

import com.sturdy.moneyallaround.common.audit.BaseEntity;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

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

    /*
        판매 글 관련 정보
     */
    @Column(nullable = false)
    private String title;
    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;
    @Column(nullable = false)
    private String thumbnailImageUrl;

    /*
        거래 상태 : 대기(WAIT), 예약 중(PROGRESS), 완료(COMPLETE)
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TradeStatus status;

    /*
        판매 상품 및 금액 정보
     */
    @Column(nullable = false)
    private String countryCode;
    @Column(nullable = false)
    private Integer foreignCurrencyAmount;
    @Column(nullable = false)
    private Integer koreanWonAmount;
    @Column(nullable = false)
    private Double koreanWonPerForeignCurrency;

    /*
        직거래 위치 정보
     */
    @Column(nullable = false)
    private Double latitude;
    @Column(nullable = false)
    private Double longitude;

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

    /*
        거래 타입 : 직거래(DIRECT), 택배거래(DELIVERY)
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TradeType type;

    /*
        판매 글 삭제 유무
     */
    @Column(nullable = false)
    private Boolean isDeleted;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "seller_id", nullable = false)
    private Member seller;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "buyer_id", nullable = true)
    private Member buyer;

    /*
        이미지 url 리스트
     */
    @OneToMany(mappedBy = "trade", cascade = CascadeType.ALL)
    private List<TradeImage> imageList = new ArrayList<>();

    /*
        판매글 관심 리스트
     */
    @OneToMany(mappedBy = "trade", cascade = CascadeType.ALL)
    private List<TradeLike> likeList = new ArrayList<>();

    @Builder
    public Trade(String title, String description, String thumbnailImageUrl,
                 String countryCode, Integer foreignCurrencyAmount, Integer koreanWonAmount,
                 Double latitude, Double longitude,
                 String country, String administrativeArea, String subAdministrativeArea, String locality, String subLocality, String thoroughfare,
                 Member seller) {
        this.title = title;
        this.description = description;
        this.thumbnailImageUrl = thumbnailImageUrl;
        status = TradeStatus.WAIT;
        this.countryCode = countryCode;
        this.foreignCurrencyAmount = foreignCurrencyAmount;
        this.koreanWonAmount = koreanWonAmount;
        koreanWonPerForeignCurrency = (double)koreanWonAmount / (double)foreignCurrencyAmount;
        this.latitude = latitude;
        this.longitude = longitude;
        this.country = country;
        this.administrativeArea = administrativeArea;
        this.subAdministrativeArea = subAdministrativeArea;
        this.locality = locality;
        this.subLocality = subLocality;
        this.thoroughfare = thoroughfare;
        type = TradeType.DIRECT;
        isDeleted = false;
        this.seller = seller;
    }

    public void update(String title, String description, String thumbnailImageUrl,
                       String countryCode, Integer foreignCurrencyAmount, Integer koreanWonAmount,
                       Double latitude, Double longitude,
                       String country, String administrativeArea, String subAdministrativeArea, String locality, String subLocality, String thoroughfare) {
        this.title = title;
        this.description = description;
        this.thumbnailImageUrl = thumbnailImageUrl;
        this.countryCode = countryCode;
        this.foreignCurrencyAmount = foreignCurrencyAmount;
        this.koreanWonAmount = koreanWonAmount;
        koreanWonPerForeignCurrency = (double)koreanWonAmount / (double)foreignCurrencyAmount;
        this.latitude = latitude;
        this.longitude = longitude;
        this.country = country;
        this.administrativeArea = administrativeArea;
        this.subAdministrativeArea = subAdministrativeArea;
        this.locality = locality;
        this.subLocality = subLocality;
        this.thoroughfare = thoroughfare;
    }

    public void delete() {
        isDeleted = true;
    }

    public void makeDirectPromise(Member buyer) {
        status = TradeStatus.PROGRESS;
        type = TradeType.DIRECT;
        this.buyer = buyer;
    }

    public void makeDeliveryPromise(Member buyer) {
        status = TradeStatus.PROGRESS;
        type = TradeType.DELIVERY;
        this.buyer = buyer;
    }

    public void cancelPromise() {
        status = TradeStatus.WAIT;
        type = TradeType.DIRECT;
        buyer = null;
    }

    public void complete() {
        status = TradeStatus.COMPLETE;
    }

    public void addImages(List<TradeImage> tradeImages) {
        this.imageList.addAll(tradeImages);
    }

    public void clearImageList() {
        this.imageList.clear();
    }
}