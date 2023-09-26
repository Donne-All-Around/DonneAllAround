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
import java.util.Iterator;
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
    private Double koreanWonPerForeignCurrency;

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
    private Boolean isDeleted;

    // 직거래 일시
    @Column(nullable = true, columnDefinition = "datetime")
    private LocalDateTime directTradeTime;

    // 직거래 장소
    @Column(nullable = true)
    private String directTradeLocationDetail;

    @Column(nullable = true)
    private String sellerAccountBankCode;

    // 판매자 계좌번호
    @Column(nullable = true)
    private String sellerAccountNumber;

    // 택배 수취인 이름
    @Column(nullable = true)
    private String deliveryRecipientName;

    // 택배 수취인 전화번호
    @Column(nullable = true)
    private String deliveryRecipientTel;

    // 배송지 우편번호
    @Column(nullable = true)
    private String deliveryAddressZipCode;

    // 배송지
    @Column(nullable = true)
    private String deliveryAddress;

    // 배송지 상세주소
    @Column(nullable = true)
    private String deliveryAddressDetail;

    // 송장번호
    @Column(nullable = true)
    private String trackingNumber;

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
        koreanWonPerForeignCurrency = (double)koreanWonAmount / (double)foreignCurrencyAmount;
        this.latitude = latitude;
        this.longitude = longitude;
        this.preferredTradeCountry = preferredTradeCountry;
        this.preferredTradeCity = preferredTradeCity;
        this.preferredTradeDistrict = preferredTradeDistrict;
        this.preferredTradeTown = preferredTradeTown;
        type = TradeType.DIRECT;
        isDeleted = false;
        this.seller = seller;
    }

    public void update(String title, String description, String thumbnailImageUrl, String countryCode, Integer foreignCurrencyAmount, Integer koreanWonAmount, Double latitude, Double longitude, String preferredTradeCountry, String preferredTradeCity, String preferredTradeDistrict, String preferredTradeTown) {
        this.title = title;
        this.description = description;
        this.thumbnailImageUrl = thumbnailImageUrl;
        this.countryCode = countryCode;
        this.foreignCurrencyAmount = foreignCurrencyAmount;
        this.koreanWonAmount = koreanWonAmount;
        koreanWonPerForeignCurrency = (double)koreanWonAmount / (double)foreignCurrencyAmount;
        this.latitude = latitude;
        this.longitude = longitude;
        this.preferredTradeCountry = preferredTradeCountry;
        this.preferredTradeCity = preferredTradeCity;
        this.preferredTradeDistrict = preferredTradeDistrict;
        this.preferredTradeTown = preferredTradeTown;
    }

    public void delete() {
        isDeleted = true;
    }

    public void makeDirectPromise(Member buyer, LocalDateTime directTradeTime, String directTradeLocationDetail) {
        status = TradeStatus.PROGRESS;
        type = TradeType.DIRECT;
        this.buyer = buyer;
        this.directTradeTime = directTradeTime;
        this.directTradeLocationDetail = directTradeLocationDetail;
    }

    public void makeDeliveryPromise(Member buyer) {
        status = TradeStatus.PROGRESS;
        type = TradeType.DELIVERY;
        this.buyer = buyer;
    }

    public void updateDirectPromise(LocalDateTime directTradeTime, String directTradeLocationDetail) {
        this.directTradeTime = directTradeTime;
        this.directTradeLocationDetail = directTradeLocationDetail;
    }

    public void updateSellerAccountNumber(String sellerAccountBankCode, String sellerAccountNumber) {
        this.sellerAccountBankCode = sellerAccountBankCode;
        this.sellerAccountNumber = sellerAccountNumber;
    }

    public void updateDeliveryInfo(String deliveryRecipientName, String deliveryRecipientTel, String deliveryAddressZipCode, String deliveryAddress, String deliveryAddressDetail) {
        this.deliveryRecipientName = deliveryRecipientName;
        this.deliveryRecipientTel = deliveryRecipientTel;
        this.deliveryAddressZipCode = deliveryAddressZipCode;
        this.deliveryAddress = deliveryAddress;
        this.deliveryAddressDetail = deliveryAddressDetail;
    }

    public void updateTrackingNumber(String trackingNumber) {
        this.trackingNumber = trackingNumber;
    }

    public void cancelPromise() {
        status = TradeStatus.WAIT;
        type = TradeType.DIRECT;
        buyer = null;
        directTradeTime = null;
        directTradeLocationDetail = null;
        sellerAccountBankCode = null;
        sellerAccountNumber = null;
        deliveryRecipientName = null;
        deliveryRecipientTel = null;
        deliveryAddressZipCode = null;
        deliveryAddress = null;
        deliveryAddressDetail = null;
        trackingNumber = null;
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