package com.sturdy.moneyallaround.domain.trade.service;

import com.sturdy.moneyallaround.domain.trade.dto.request.TradeCreateRequestDto;
import com.sturdy.moneyallaround.domain.trade.dto.request.TradeListRequestDto;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import com.sturdy.moneyallaround.domain.trade.entity.TradeStatus;
import com.sturdy.moneyallaround.domain.trade.repository.TradeRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.lang.reflect.Member;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class TradeService {
    private final TradeRepository tradeRepository;

    public Slice<Trade> findAll(TradeListRequestDto tradeListRequestDto, Pageable pageable) {
        return tradeRepository.findAll(tradeListRequestDto, pageable);
    }

    public Slice<Trade> getProgressTradeSellHistory(Long lastTradeId, Long sellerId, Pageable pageable) {
        return tradeRepository.findBySellerAndStatus(lastTradeId, TradeStatus.PROGRESS, pageable);
    }

//    @Transactional
//    public Trade createTrade(TradeCreateRequestDto tradeCreateRequestDto, Long sellerId) {
//        return tradeRepository.save(tradeCreateRequestDto.toTrade(seller));
//    }

    public Trade getById(Long tradeId) {
        return tradeRepository.findById(tradeId).orElseThrow(EntityNotFoundException::new);
    }
}
