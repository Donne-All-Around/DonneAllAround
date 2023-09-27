package com.sturdy.moneyallaround.domain.member.service;

import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;
import com.sturdy.moneyallaround.Exception.model.TokenNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.annotation.Id;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
//Redis 사용하여 토큰 저장, 가져오고, 삭제하는 서비스
public class RefreshTokenService {

    private final RedisTemplate redisTemplate; //Redis DB와 상호 작용할 수 있게함

    //Redis에 토큰과 해당 멤버 ID 저장 ValueOperation 사용하여 키-값을 저장하는 역할
    public void setValues(String token, String tel){
        ValueOperations<String, String> values = redisTemplate.opsForValue();
        try {
            values.set(token,tel);
        } catch (Exception e) {
            log.info("Redis save error");
            throw new IllegalArgumentException();
        }
    }

    //특정 토큰의 멤버 ID 가져오고 토큰 통해 멤버 ID 검색하고 반환
    public String getValues(String token){
        //get메서드 호출하면 해당 레디스 토큰 값 읽어온다 (키/value 가져오기)
        ValueOperations<String, String> values = redisTemplate.opsForValue();
        try {
            return values.get(token);
        } catch (RuntimeException e) {
            log.info("Redis get error");
            throw new TokenNotFoundException(ExceptionMessage.TOKEN_NOT_FOUND);
        }
    }

    //특정 토큰 삭제하여 토큰 무효화
    public void delValues(String token) throws TokenNotFoundException {
        try{
            redisTemplate.delete(token);
        }catch (RuntimeException e){
            log.info("Redis delete error");
            throw new TokenNotFoundException(ExceptionMessage.TOKEN_NOT_FOUND);
        }
    }


}
