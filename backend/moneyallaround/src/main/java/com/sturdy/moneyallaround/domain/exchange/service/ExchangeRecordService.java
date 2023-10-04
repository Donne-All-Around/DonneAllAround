package com.sturdy.moneyallaround.domain.exchange.service;

import com.sturdy.moneyallaround.domain.exchange.dto.request.ExchangeRecordRequestDto;
import com.sturdy.moneyallaround.domain.exchange.entity.ExchangeRecord;
import com.sturdy.moneyallaround.domain.exchange.repository.ExchangeRecordRepository;
import com.sturdy.moneyallaround.domain.member.service.MemberService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class ExchangeRecordService {
    private final ExchangeRecordRepository exchangeRecordRepository;
    private final MemberService memberService;

    public Slice<ExchangeRecord> findByMember(String memberTel, Long lastExchangeRecordId, Pageable pageable) {
        return exchangeRecordRepository.findByMember(memberService.findByTel(memberTel), lastExchangeRecordId, pageable);
    }

    @Transactional
    public ExchangeRecord createExchangeRecord(ExchangeRecordRequestDto exchangeRecordRequestDto, String memberTel) {
        return exchangeRecordRepository.save(exchangeRecordRequestDto.toExchangeRecord(memberService.findByTel(memberTel)));
    }

    @Transactional
    public void deleteExchangeRecord(Long exchangeRecordId) {
        exchangeRecordRepository.delete(findExchangeTrade(exchangeRecordId));
    }

    @Transactional
    public ExchangeRecord updateExchangeRecord(ExchangeRecordRequestDto exchangeRecordRequestDto, Long exchangeRecordId) {
        findExchangeTrade(exchangeRecordId).update(exchangeRecordRequestDto.countryCode(), exchangeRecordRequestDto.bankCode(), exchangeRecordRequestDto.koreanWonAmount(), exchangeRecordRequestDto.foreignCurrencyAmount(), exchangeRecordRequestDto.tradingBaseRate(), exchangeRecordRequestDto.preferentialRate(), exchangeRecordRequestDto.exchangeDate());
        return findExchangeTrade(exchangeRecordId);
    }

    public ExchangeRecord findExchangeTrade(Long exchangeRecordId) {
        return exchangeRecordRepository.findById(exchangeRecordId).orElseThrow(EntityNotFoundException::new);
    }
}
