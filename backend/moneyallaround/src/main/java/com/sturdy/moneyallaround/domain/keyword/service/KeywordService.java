package com.sturdy.moneyallaround.domain.keyword.service;

import com.sturdy.moneyallaround.domain.keyword.dto.request.KeywordRequestDto;
import com.sturdy.moneyallaround.domain.keyword.entity.Keyword;
import com.sturdy.moneyallaround.domain.keyword.repository.KeywordRepository;
import com.sturdy.moneyallaround.domain.member.service.MemberService;
import com.sturdy.moneyallaround.domain.trade.entity.Trade;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class KeywordService {
    private final KeywordRepository keywordRepository;
    private final MemberService memberService;

    @Transactional
    public void createKeyword(KeywordRequestDto keywordRequestDto, Long memberId) {
        keywordRepository.save(keywordRequestDto.toKeyword(memberService.findById(memberId)));
    }

    @Transactional
    public void deleteKeyword(Long keywordId) {
        keywordRepository.deleteById(keywordId);
    }

    public List<Keyword> findAll(Long memberId) {
        return keywordRepository.findByMemberOrderByCreateTimeDesc(memberService.findById(memberId));
    }

    public Boolean existKeyword(KeywordRequestDto keywordRequestDto, Long memberId) {
        return keywordRepository.existsByCountryCodeAndPreferredTradeCityAndPreferredTradeCityAndPreferredTradeDistrictAndPreferredTradeTownAndMember(
                keywordRequestDto.countryCode(),
                keywordRequestDto.preferredTradeCountry(),
                keywordRequestDto.preferredTradeCity(),
                keywordRequestDto.preferredTradeDistrict(),
                keywordRequestDto.preferredTradeTown(),
                memberService.findById(memberId)
        );
    }

    public List<Keyword> findByTrade(String countryCode, String preferredTradeCountry, String preferredTradeCity, String preferredTradeDistrict, String preferredTradeTown) {
        return keywordRepository.findByCountryCodeAndPreferredTradeLocation(countryCode, preferredTradeCountry, preferredTradeCity, preferredTradeDistrict, preferredTradeTown);
    }
}
