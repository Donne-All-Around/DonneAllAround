package com.sturdy.moneyallaround.domain.member.repository;

import com.sturdy.moneyallaround.domain.member.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

    public interface MemberRepository extends JpaRepository<Member, String> {
        Optional<Member> findById(Long memberId);
        Optional<Member> findByTel(String tel);
        Optional<Member> findByNickname(String nickname);

        Boolean existsByNickname(String nickname);
        Boolean existsByTel(String tel);
}
