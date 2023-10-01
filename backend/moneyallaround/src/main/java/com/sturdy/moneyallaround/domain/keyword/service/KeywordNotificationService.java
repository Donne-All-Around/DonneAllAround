package com.sturdy.moneyallaround.domain.keyword.service;

import com.sturdy.moneyallaround.domain.keyword.entity.KeywordNotification;
import com.sturdy.moneyallaround.domain.keyword.repository.KeywordNotificationRepository;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class KeywordNotificationService {
    private final KeywordNotificationRepository keywordNotificationRepository;
    private final KeywordService keywordService;

    @Transactional
    public void createKeywordNotification(Trade trade) {
        keywordNotificationRepository.saveAll(keywordService.findByTrade(trade)
                .stream().map(keyword -> new KeywordNotification(trade, keyword.getMember())).toList());
    }

    @Transactional
    public void deleteKeywordNotification(Long keywordNotificationId) {
        keywordNotificationRepository.deleteById(keywordNotificationId);
    }
}
