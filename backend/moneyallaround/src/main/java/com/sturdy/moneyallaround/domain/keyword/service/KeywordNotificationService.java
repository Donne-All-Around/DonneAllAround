package com.sturdy.moneyallaround.domain.keyword.service;

import com.sturdy.moneyallaround.config.firebase.FCMService;
import com.sturdy.moneyallaround.domain.keyword.entity.KeywordNotification;
import com.sturdy.moneyallaround.domain.keyword.repository.KeywordNotificationRepository;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class KeywordNotificationService {
    private final KeywordNotificationRepository keywordNotificationRepository;
    private final KeywordService keywordService;
    private final FCMService fcmService;

    @Transactional
    public void createKeywordNotification(Trade trade) {
        List<KeywordNotification> notificationList = keywordNotificationRepository.saveAll(keywordService.findByTrade(trade)
                .stream().map(keyword -> new KeywordNotification(trade, keyword.getMember())).toList());

        String title = "[돈네한바퀴 키워드 알림]";
        String body = "희망 거래가 등록되었어요!";

        for (KeywordNotification keywordNotification : notificationList) {
            String deviceToken = keywordNotification.getMember().getDeviceToken();
            if (deviceToken != null) {
                fcmService.sendNotificationByToken(title, body, deviceToken);
            }
        }
    }

    @Transactional
    public void deleteKeywordNotification(Long keywordNotificationId) {
        keywordNotificationRepository.deleteById(keywordNotificationId);
    }
}
