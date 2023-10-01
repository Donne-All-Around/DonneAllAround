package com.sturdy.moneyallaround.domain.keyword.service;

import com.google.firebase.messaging.FirebaseMessagingException;
import com.sturdy.moneyallaround.config.firebase.FCMService;
import com.sturdy.moneyallaround.domain.keyword.entity.KeywordNotification;
import com.sturdy.moneyallaround.domain.keyword.repository.KeywordNotificationRepository;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
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

        StringBuilder body = new StringBuilder();
        body.append(trade.getPreferredTradeCountry()).append(" ")
                .append(trade.getPreferredTradeCity()).append(" ")
                .append(trade.getPreferredTradeDistrict()).append(" ")
                .append(trade.getPreferredTradeTown()).append(" [")
                .append(trade.getCountryCode()).append("]");

        /*
            수정 필요
            추후 전화번호가 아닌 멤버 엔티티 안에 fcm 토큰으로 변경하기
         */
        try {
            fcmService.sendMulticastMessageTo("돈네한바퀴", body.toString(), notificationList.stream().map(notification -> notification.getMember().getTel()).toList());
        } catch (Exception e) {
            log.error(e.getMessage());
        }
    }

    @Transactional
    public void deleteKeywordNotification(Long keywordNotificationId) {
        keywordNotificationRepository.deleteById(keywordNotificationId);
    }
}
