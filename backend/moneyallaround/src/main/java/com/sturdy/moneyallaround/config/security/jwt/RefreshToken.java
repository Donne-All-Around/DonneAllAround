package com.sturdy.moneyallaround.config.security.jwt;

import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.data.redis.core.RedisHash;

//Redis를 사용하여 리프레시 토큰을 저장하고 관리
@AllArgsConstructor //왜자꾸 까먹지? 생성자 자동 생성
@Getter
//Redis 해시 데이터 구조를 표현하는 어노테이션
@RedisHash(value = "jwtToken" , timeToLive = 60*60*24*14) //60초 60분 24시간 14일
public class RefreshToken {

    @Id
    private Long memberId;

    private String refreshToken;

    private String accessToken;
}
