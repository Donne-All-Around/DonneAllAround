package com.sturdy.moneyallaround.domain.exchange.controller;

import com.google.cloud.firestore.Firestore;
import com.google.firebase.cloud.FirestoreClient;
import com.sturdy.moneyallaround.config.firebase.FCMService;
import com.sturdy.moneyallaround.domain.exchange.dto.request.TokenRequestDto;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Slf4j
@RestController
@RequestMapping("/api/exchange")
@RequiredArgsConstructor
public class ExchangeController {
    @Value("${exchange.key}")
    private String API_KEY;

    private final FCMService fcmService;

    @Getter
    static class ExchangeInfo {
        Double close;
        Date date;

        public ExchangeInfo(Double close, Date date) {
            this.close = close;
            this.date = date;
        }
    }

    @Scheduled(cron = "0 0 3 * * *", zone = "Asia/Seoul")
    public ResponseEntity<Map<String, Object>> saveExchangeHistory() throws ParseException {
        // 한국 시간으로 타임 존 설정
        TimeZone tz = TimeZone.getTimeZone("Asia/Seoul");
        // 현재 날짜 구하기
        Calendar cal  = Calendar.getInstance(tz);
        // 하루 전 날짜 구하기
        cal.add(Calendar.DATE, -1);
        // 날짜 포맷
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String date = sdf.format(cal.getTime());

        StringBuilder apiUrl = new StringBuilder();
        apiUrl.append("http://api.currencylayer.com/historical?access_key=").append(API_KEY);
        apiUrl.append("&date=").append(date);
        apiUrl.append("&currencies=").append("KRW,AUD,CAD,CNY,CZK,EUR,GBP,HKD,JPY,NZD,PHP,RUB,SGD,TWD,USD,VND");

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<Map> responseEntity =
                restTemplate.exchange(
                        apiUrl.toString(),
                        HttpMethod.GET,
                        new HttpEntity<>(new HttpHeaders()),
                        Map.class
                );

        Map<String, Object> quotes = (Map<String, Object>)(responseEntity.getBody().get("quotes"));

        Firestore firestore = FirestoreClient.getFirestore();

        double usdClose;
        if (quotes.get("USDKRW") instanceof Double) {
            usdClose = (Double) quotes.get("USDKRW");
        } else {
            usdClose = ((Integer) quotes.get("USDKRW")).doubleValue();
        }
        firestore.collection("exchange_rate_USD").add(new ExchangeInfo(usdClose, sdf.parse(date)));

        double audClose;
        if (quotes.get("USDAUD") instanceof Double) {
            audClose = usdClose / (Double) quotes.get("USDAUD");
        } else {
            audClose = usdClose / ((Integer) quotes.get("USDAUD")).doubleValue();
        }
        firestore.collection("exchange_rate_AUD").add(new ExchangeInfo(audClose, sdf.parse(date)));

        double cadClose;
        if (quotes.get("USDCAD") instanceof Double) {
            cadClose = usdClose / (Double) quotes.get("USDCAD");
        } else {
            cadClose = usdClose / ((Integer) quotes.get("USDCAD")).doubleValue();
        }
        firestore.collection("exchange_rate_CAD").add(new ExchangeInfo(cadClose, sdf.parse(date)));

        double cnyClose;
        if (quotes.get("USDCNY") instanceof Double) {
            cnyClose = usdClose / (Double) quotes.get("USDCNY");
        } else {
            cnyClose = usdClose / ((Integer) quotes.get("USDCNY")).doubleValue();
        }
        firestore.collection("exchange_rate_CNY").add(new ExchangeInfo(cnyClose, sdf.parse(date)));

        double czkClose;
        if (quotes.get("USDCZK") instanceof Double) {
            czkClose = usdClose / (Double) quotes.get("USDCZK");
        } else {
            czkClose = usdClose / ((Integer) quotes.get("USDCZK")).doubleValue();
        }
        firestore.collection("exchange_rate_CZK").add(new ExchangeInfo(czkClose, sdf.parse(date)));

        double eurClose;
        if (quotes.get("USDEUR") instanceof Double) {
            eurClose = usdClose / (Double) quotes.get("USDEUR");
        } else {
            eurClose = usdClose / ((Integer) quotes.get("USDEUR")).doubleValue();
        }
        firestore.collection("exchange_rate_EUR").add(new ExchangeInfo(eurClose, sdf.parse(date)));

        double gpbClose;
        if (quotes.get("USDGBP") instanceof Double) {
            gpbClose = usdClose / (Double) quotes.get("USDGBP");
        } else {
            gpbClose = usdClose / ((Integer) quotes.get("USDGBP")).doubleValue();
        }
        firestore.collection("exchange_rate_GBP").add(new ExchangeInfo(gpbClose, sdf.parse(date)));

        double hkdClose;
        if (quotes.get("USDHKD") instanceof Double) {
            hkdClose = usdClose / (Double) quotes.get("USDHKD");
        } else {
            hkdClose = usdClose / ((Integer) quotes.get("USDHKD")).doubleValue();
        }
        firestore.collection("exchange_rate_HKD").add(new ExchangeInfo(hkdClose, sdf.parse(date)));

        double jpyClose;
        if (quotes.get("USDJPY") instanceof Double) {
            jpyClose = (usdClose / (Double) quotes.get("USDJPY")) * 100.0;
        } else {
            jpyClose = (usdClose / ((Integer) quotes.get("USDJPY")).doubleValue()) * 100.0;
        }
        firestore.collection("exchange_rate_JPY").add(new ExchangeInfo(jpyClose, sdf.parse(date)));

        double nzdClose;
        if (quotes.get("USDNZD") instanceof Double) {
            nzdClose = usdClose / (Double) quotes.get("USDNZD");
        } else {
            nzdClose = usdClose / ((Integer) quotes.get("USDNZD")).doubleValue();
        }
        firestore.collection("exchange_rate_NZD").add(new ExchangeInfo(nzdClose, sdf.parse(date)));

        double phpClose;
        if (quotes.get("USDPHP") instanceof Double) {
            phpClose = usdClose / (Double) quotes.get("USDPHP");
        } else {
            phpClose = usdClose / ((Integer) quotes.get("USDPHP")).doubleValue();
        }
        firestore.collection("exchange_rate_PHP").add(new ExchangeInfo(phpClose, sdf.parse(date)));

        double rubClose;
        if (quotes.get("USDRUB") instanceof Double) {
            rubClose = usdClose / (Double) quotes.get("USDRUB");
        } else {
            rubClose = usdClose / ((Integer) quotes.get("USDRUB")).doubleValue();
        }
        firestore.collection("exchange_rate_RUB").add(new ExchangeInfo(rubClose, sdf.parse(date)));

        double sgdClose;
        if (quotes.get("USDSGD") instanceof Double) {
            sgdClose = usdClose / (Double) quotes.get("USDSGD");
        } else {
            sgdClose = usdClose / ((Integer) quotes.get("USDSGD")).doubleValue();
        }
        firestore.collection("exchange_rate_SGD").add(new ExchangeInfo(sgdClose, sdf.parse(date)));

        double twdClose;
        if (quotes.get("USDTWD") instanceof Double) {
            twdClose = usdClose / (Double) quotes.get("USDTWD");
        } else {
            twdClose = usdClose / ((Integer) quotes.get("USDTWD")).doubleValue();
        }
        firestore.collection("exchange_rate_TWD").add(new ExchangeInfo(twdClose, sdf.parse(date)));

        double vndClose;
        if (quotes.get("USDVND") instanceof Double) {
            vndClose = (usdClose / (Double) quotes.get("USDVND")) * 100.0;
        } else {
            vndClose = (usdClose / ((Integer) quotes.get("USDVND")).doubleValue()) * 100.0;
        }
        firestore.collection("exchange_rate_VND").add(new ExchangeInfo(vndClose, sdf.parse(date)));

        return ResponseEntity.ok().build();
    }
}
