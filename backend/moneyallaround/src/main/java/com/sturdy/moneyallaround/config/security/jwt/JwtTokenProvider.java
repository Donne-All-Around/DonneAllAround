package com.sturdy.moneyallaround.config.security.jwt;


import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;
import com.sturdy.moneyallaround.Exception.model.TokenCheckFailException;
import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;
import java.util.stream.Collectors;

@Slf4j
@Component
public class JwtTokenProvider {

    private final Key key;
    //토큰 생성 및 유효성 검사에 사용되는 시크릿 키 초기화 역할
    public JwtTokenProvider(@Value("1ntpYfNvwBU9ay1hz10ESI6esspQmbN3") String secretKey) {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        this.key = Keys.hmacShaKeyFor(keyBytes);
    }




    public TokenInfo generateToken(Authentication authentication) {
        String accessToken = createAccessToken(authentication);
        String refreshToken = createRefreshToken();

        return TokenInfo.builder()
                .grantType("Bearer")
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

    public TokenInfo generateAccessToken(Authentication authentication){
        String accessToken = createAccessToken(authentication);
        return TokenInfo.builder()
                .grantType("Bearer")
                .accessToken(accessToken)
                .build();
    }

    private String createRefreshToken() {
        long now = (new Date()).getTime();
        return (
                Jwts.builder()
                        .setExpiration(new Date(now + 60*60*24*14*1000))
                        .signWith(key, SignatureAlgorithm.HS256)
                        .compact()
                );
    }


    private String createAccessToken(Authentication authentication) {
        String authorities = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.joining(","));

        long now = (new Date()).getTime();
        //access token 생성
        Date accessTokenExpiresIn = new Date(now + 60*60*24*1000);

        return (
                Jwts.builder()
                        .setSubject(authentication.getName())
                        .claim("auth", authorities)
                        .setExpiration(accessTokenExpiresIn)
                        .signWith(key, SignatureAlgorithm.HS256)
                        .compact()
                );

    }

    //토큰 유효한지 아닌지 검사하시오
    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
            return true;
        } catch (SecurityException | MalformedJwtException e) {
            log.info("Invalid JWT Token", e);
            throw new TokenCheckFailException(ExceptionMessage.FAIL_TOKEN_CHECK);
        } catch (ExpiredJwtException e) {
            log.info("Expired JWT Token", e);
            throw new TokenCheckFailException(ExceptionMessage.TOKEN_VALID_TIME_EXPIRED);
        } catch (UnsupportedJwtException e) {
            log.info("Unsupported JWT Token", e);
            throw new TokenCheckFailException(ExceptionMessage.FAIL_TOKEN_CHECK);
        } catch (IllegalArgumentException e) {
            log.info("JWT claims string is empty", e);
            throw new TokenCheckFailException(ExceptionMessage.TOKEN_NOT_FOUND);
        }
    }

    public boolean expiredToken(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
            return true;
        } catch (ExpiredJwtException e) {
            log.info("Expired JWT Token", e);
        }
        return false;
    }

    // JWT 토큰을 복호화하여 토큰에 들어있는 정보를 꺼내는 메서드


}
