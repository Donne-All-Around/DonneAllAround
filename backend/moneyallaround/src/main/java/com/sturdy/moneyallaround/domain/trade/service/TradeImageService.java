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

//    public void createTradeImage(List<String> urlList, Trade trade) {
//        for (int i = 0; i < urlList.size(); i++) {
//            tradeImageRepository.save(new TradeImage(urlList.get(i), i == 0, trade));
//        }
//    }

    public List<TradeImage> getTradeImage(Long tradeId) {
        return tradeImageRepository.findByTradeId(tradeId);
    }
}
