package com.sturdy.moneyallaround.domain.keyword.repository;

import com.sturdy.moneyallaround.domain.keyword.entity.Keyword;
import com.sturdy.moneyallaround.domain.member.entity.Member;
import jakarta.validation.constraints.NotNull;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface KeywordRepository extends JpaRepository<Keyword, Long>, KeywordRepositoryCustom {
    void deleteById(@NotNull Long id);
    List<Keyword> findByMemberOrderByCreateTimeDesc(Member member);
    Boolean existsByCountryCodeAndPreferredTradeCountryAndPreferredTradeCityAndPreferredTradeDistrictAndPreferredTradeTownAndMember(String countryCode, String preferredTradeCountry, String preferredTradeCity, String preferredTradeDistrict, String preferredTradeTown, Member member);
}
