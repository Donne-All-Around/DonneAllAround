package com.sturdy.moneyallaround.domain.trade.service;

import com.sturdy.moneyallaround.domain.trade.entity.TradeImage;
import com.sturdy.moneyallaround.domain.trade.repository.TradeImageRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class TradeImageService {
    private final TradeImageRepository tradeImageRepository;

    @Transactional
    public void deleteTradeImages(List<TradeImage> tradeImages) {
        tradeImageRepository.deleteAll(tradeImages);
    }
}
