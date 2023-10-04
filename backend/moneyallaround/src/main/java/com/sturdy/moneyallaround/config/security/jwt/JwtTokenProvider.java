package com.sturdy.moneyallaround.config.security.jwt;


import com.google.api.client.auth.oauth2.TokenRequest;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import com.google.rpc.context.AttributeContext;
import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;
import com.sturdy.moneyallaround.Exception.model.FirebaseTokenValidationException;
import com.sturdy.moneyallaround.Exception.model.TokenCheckFailException;
import com.sturdy.moneyallaround.Exception.model.TokenNotFoundException;
import com.sturdy.moneyallaround.common.ApiResponse;
import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import java.io.FileInputStream;
import java.security.Key;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static javax.crypto.Cipher.SECRET_KEY;

@Slf4j
@Component
public class JwtTokenProvider {

    private final Key key;
    private String SECRET_KEY;


    //토큰 생성 및 유효성 검사에 사용되는 시크릿 키 초기화 역할
    public JwtTokenProvider(@Value("${jwt.secret}") String secretKey) {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        this.key = Keys.hmacShaKeyFor(keyBytes);
    }

    /**
     * AccessToken : 4시간
     * RefreshToken : 14일
     */

    // 유저 전화번호를 가지고 AccessToken, RefreshToken 을 생성하는 메서드

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


    private String createAccessToken(Authentication authentication) {
        String authorities = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.joining(","));

        long now = (new Date()).getTime();
        //access token 생성
        Date accessTokenExpiresIn = new Date(now + 60*60*4*1000);

        return (
                Jwts.builder()
                        .setSubject(authentication.getName())
                        .claim("auth", authorities)
                        .setExpiration(accessTokenExpiresIn)
                        .signWith(key, SignatureAlgorithm.HS256)
                        .compact()
                );

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
    public Authentication getAuthentication(String accessToken) {
        // 토큰 복호화
        Claims claims = parseClaims(accessToken);

        if (claims.get("auth") == null) {
            throw new TokenNotFoundException(ExceptionMessage.TOKEN_NOT_FOUND);
        }
        // 클레임에서 권한 정보 가져오기
        Collection<? extends GrantedAuthority> authorities =
                Arrays.stream(claims.get("auth").toString().split(","))
                        .map(SimpleGrantedAuthority::new)
                        .toList();

        // UserDetails 객체를 만들어서 Authentication 리턴
        UserDetails principal = new User(claims.getSubject(), "", authorities);
        return new UsernamePasswordAuthenticationToken(principal, "", authorities);
    }


    //accessToken에서 클레임 추출
    private Claims parseClaims(String accessToken) {
        try {
            return Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(accessToken).getBody();
        } catch (ExpiredJwtException e) {
            return e.getClaims();
        }
    }

    //    public String extractTel(String token) {
//        return extractClaim(token, Claims::getSubject);
//    }
//
//    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
//        final Claims claims = extractAllClaims(token);
//        return claimsResolver.apply(claims);
//    }
//
//    // extractAllclaims() : 토큰이 유효한 토큰인지 검사한 후, 토큰에 담긴 Payload 값을 가져온다.
//    private Claims extractAllClaims(String token) {
//        return Jwts
//                .parserBuilder()
//                .setSigningKey(getSignInKey())
//                .build()
//                .parseClaimsJws(token)
//                .getBody();
//    }
//
//    private Key getSignInKey() {
//        byte[] keyBytes = Decoders.BASE64URL.decode(SECRET_KEY);
//        return Keys.hmacShaKeyFor(keyBytes);
//    }


}
