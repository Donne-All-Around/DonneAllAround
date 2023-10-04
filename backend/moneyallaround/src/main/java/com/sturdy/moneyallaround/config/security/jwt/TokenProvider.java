package com.sturdy.moneyallaround.config.security.jwt;

import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;
import com.sturdy.moneyallaround.Exception.model.TokenCheckFailException;
import com.sturdy.moneyallaround.Exception.model.TokenNotFoundException;
import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.stream.Collectors;

/*
    토큰의 생성, 인증 정보 조회, 유효성 검증, 암호화 설정 등의 역할 수행
 */
@Slf4j
@Component
public class TokenProvider {
    private final Key key;

    public TokenProvider(@Value("${jwt.secret}") String secretKey) {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        this.key = Keys.hmacShaKeyFor(keyBytes);
    }

    /*
        유저 정보를 가지고 AccessToken, RefreshToken을 생성하는 메서드
     */
    public TokenInfo generateToken(Authentication authentication) {
        String accessToken = createAccessToken(authentication);
        String refreshToken = createRefreshToken();

        return TokenInfo.builder()
                .grantType("Bearer")
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

    private String createAccessToken(Authentication authentication) {
        String authorities = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.joining(","));

        long now = (new Date()).getTime();

        /*
            access token 유효시간 수정 필요
         */
        Date accessTokenExpiresIn = new Date(now + 60*60*24*1000);

        return Jwts.builder()
                .setSubject(authentication.getName()) // 사용자 전화번호
                .claim("auth", authorities)
                .setExpiration(accessTokenExpiresIn)
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

    private String createRefreshToken() {
        long now = (new Date()).getTime();
        Date refreshTokenExpiresIn = new Date(now + 60*60*24*14*1000);

        return Jwts.builder()
                .setExpiration(refreshTokenExpiresIn)
                .signWith(key, SignatureAlgorithm.HS256)
                .compact();
    }

    public Authentication getAuthentication(String accessToken) {
        Claims claims = parseClaims(accessToken);

        if (claims.get("auth") == null) {
            throw new TokenNotFoundException(ExceptionMessage.AUTH_NOT_FOUND);
        }

        Collection<? extends GrantedAuthority> authorities =
                Arrays.stream(claims.get("auth").toString().split(","))
                        .map(SimpleGrantedAuthority::new)
                        .toList();

        UserDetails principal = new User(claims.getSubject(), "", authorities);
        return new UsernamePasswordAuthenticationToken(principal, "", authorities);
    }

    private Claims parseClaims(String accessToken) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(accessToken)
                    .getBody();
        } catch (ExpiredJwtException e) {
            return e.getClaims();
        }
    }

    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
            return true;
        } catch (io.jsonwebtoken.security.SecurityException | MalformedJwtException e) {
            log.info("잘못된 JWT 토큰", e);
            throw new TokenCheckFailException(ExceptionMessage.FAIL_TOKEN_CHECK);
        } catch (ExpiredJwtException e) {
            log.info("만료된 JWT 토큰", e);
            throw new TokenCheckFailException(ExceptionMessage.TOKEN_VALID_TIME_EXPIRED);
        } catch (UnsupportedJwtException e) {
            log.info("지원하지 않는 JWT 토큰", e);
            throw new TokenCheckFailException(ExceptionMessage.FAIL_TOKEN_CHECK);
        } catch (IllegalArgumentException e) {
            log.info("JWT claims에 값이 존재하지 않습니다.", e);
            throw new TokenCheckFailException(ExceptionMessage.TOKEN_NOT_FOUND);
        }
    }

    public boolean checkExpiredToken(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
            return true;
        } catch (ExpiredJwtException e) {
            log.info("JWT 토큰 만료", e);
        }

        return false;
    }

    public TokenInfo generateAccessToken(Authentication authentication) {
        String accessToken = createAccessToken(authentication);
        return TokenInfo.builder()
                .grantType("Bearer")
                .accessToken(accessToken)
                .build();
    }
}
