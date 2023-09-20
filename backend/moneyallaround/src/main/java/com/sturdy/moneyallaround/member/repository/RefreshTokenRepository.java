package com.sturdy.moneyallaround.member.repository;

import com.sturdy.moneyallaround.config.security.jwt.RefreshToken;
import org.springframework.data.annotation.Id;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RefreshTokenRepository extends CrudRepository<RefreshToken, String> {

    @Id
    Optional<RefreshToken> findByAccessToken(String accessToken);

}
