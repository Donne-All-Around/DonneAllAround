package com.sturdy.moneyallaround.domain.trade.service;

import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.entity.TradeImage;
import com.sturdy.moneyallaround.domain.trade.repository.TradeImageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class TradeImageService {
    private final TradeImageRepository tradeImageRepository;

    public void createTradeImageList(List<String> imageUrlList, Trade trade) {
        imageUrlList.forEach(imageUrl -> tradeImageRepository.save(new TradeImage(imageUrl, trade)));
    }

    public void deleteTradeImageByTradeId(Long tradeId) {
        tradeImageRepository.deleteByTradeId(tradeId);
    }
}
