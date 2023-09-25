package com.sturdy.moneyallaround.member.repository;

import com.sturdy.moneyallaround.member.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

    public interface MemberRepository extends JpaRepository<Member, String> {
        Optional<Member> findById(Long memberId);
        Optional<Member> findByTel(String tel);
        Optional<Member> findByNickname(String nickname);
}
