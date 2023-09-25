package com.sturdy.moneyallaround.member.service;

import com.sturdy.moneyallaround.Exception.model.TokenNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.annotation.Id;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class RefreshTokenService {

//    public void delValues(String token) throws TokenNotFoundException {
//        try{
//            redisTemplate.delete(token);
//        }catch (RuntimeException e){
//            log.info("Redis delete error");
//            throw new TokenNotFoundException(ExceptionMessage.TOKEN_NOT_FOUND);
//        }
//    }


}
