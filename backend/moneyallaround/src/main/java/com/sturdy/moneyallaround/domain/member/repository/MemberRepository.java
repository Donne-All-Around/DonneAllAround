package com.sturdy.moneyallaround.domain.member.repository;

import com.sturdy.moneyallaround.domain.member.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MemberRepository extends JpaRepository<Member, Long> {
    Member findByTel(String tel);
}
