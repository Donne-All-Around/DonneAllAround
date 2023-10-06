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
    public void createKeyword(KeywordRequestDto keywordRequestDto, String memberTel) {
        keywordRepository.save(keywordRequestDto.toKeyword(memberService.findByTel(memberTel)));
    }

    @Transactional
    public void deleteKeyword(Long keywordId) {
        keywordRepository.deleteById(keywordId);
    }

    public List<Keyword> findAll(String memberTel) {
        return keywordRepository.findByMemberOrderByCreateTimeDesc(memberService.findByTel(memberTel));
    }

    public Boolean existKeyword(KeywordRequestDto keywordRequestDto, String memberTel) {
        return keywordRepository.existsByMemberAndLocationAndCountryCode(
                keywordRequestDto.countryCode(),
                keywordRequestDto.country(),
                keywordRequestDto.administrativeArea(),
                keywordRequestDto.subAdministrativeArea(),
                keywordRequestDto.locality(),
                keywordRequestDto.subLocality(),
                keywordRequestDto.thoroughfare(),
                memberService.findByTel(memberTel)
        );
    }

    public List<Keyword> findByTrade(Trade trade) {
        return keywordRepository.findByCountryCodeAndLocation(trade);
    }
}
