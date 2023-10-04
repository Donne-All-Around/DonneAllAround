package com.sturdy.moneyallaround.config.security.jwt;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;
import com.sturdy.moneyallaround.Exception.model.TokenCheckFailException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Enumeration;

//항상 처음 request 가 들어오면 jwtAuthentication Filter먼저 거친다
@Slf4j
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwtTokenProvider;

    //파이어베이스 토큰 유효성 검증
    public boolean isValidFirebaseToken(String firebaseToken) {
        try {
            // Firebase Admin SDK 초기화
            FileInputStream serviceAccount = new FileInputStream("donnearound-firebase-adminsdk.json"); // Firebase Admin SDK 설정 파일 경로
            FirebaseOptions options = new FirebaseOptions.Builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();
            FirebaseApp.initializeApp(options);

            // Firebase 토큰 검증
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(firebaseToken);

            // 검증에 성공하면 true 반환
            return decodedToken != null;
        } catch (Exception e) {
            // 검증에 실패하면 false 반환
            return false;
        }
    }


    //우선 request 에서 토큰이 있는지 없는지 체크하자
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        log.info("일단 여기까진 온다");
        logRequest(request);
        log.info("authentication filter start!!!");


        if(request.getRequestURI().equals("/api/member/verifyFirebaseToken") ||
                request.getRequestURI().equals("/api/member/check/nickname")
        ){
            log.info("파이어베이스 토큰 검증");
            filterChain.doFilter(request, response);
            return;
        }

//        final String authHeader = request.getHeader("Authorization");
//        final String jwtToken;
//
//        if (authHeader == null || !authHeader.startsWith("Bearer")) {
//            filterChain.doFilter(request, response);
//            return;
//        }
//        jwtToken = authHeader.substring(7);

        String token = resolveAccessToken(request);
        log.info("headerToken={}",token);

        //유효성 검사
        if(request.getRequestURI().equals("/api/member/reissue") || (token != null && jwtTokenProvider.validateToken(token))) {
            //토큰이 유효한 경우 토큰에서 authentication 객체를 가져와서 securityContext에 저장한다
            log.info("유효한 토큰입니다.");
            Authentication authentication = jwtTokenProvider.getAuthentication(token);
            log.info("authentication = {}", authentication.toString());
            SecurityContextHolder.getContext().setAuthentication(authentication);
        }else {
            log.error("유효하지 않은 토큰입니다.");
            SecurityContextHolder.clearContext();
            throw new TokenCheckFailException(ExceptionMessage.FAIL_TOKEN_CHECK);
        }
        log.info("권한 확인 완료");
        filterChain.doFilter(request, response);
    }

    //HTTP요청 정보 로그 (로그를 통해 성능 개선 코드)
    private void logRequest(HttpServletRequest request) {
        log.info(String.format(
                "[%s] %s %s",
                request.getMethod(),
                request.getRequestURI().toLowerCase(),
                request.getQueryString() == null ? "" : request.getQueryString())
        );
    }


    //request 에서 JWT 엑세스 토큰 추출 메서드
    // HttpservletRequest 객체 사용하여 클라이언트의 HTTP 요청 헤더에서 JWT 엑세스 토큰 찾아내고 반환함
    // Request Header 에서 Access Token 정보 추출
    private String resolveAccessToken(HttpServletRequest request) {
        log.info("headers={}",request.getHeaderNames());
        Enumeration eHeader = request.getHeaderNames();
        while(eHeader.hasMoreElements()){
            String requestName = (String) eHeader.nextElement();
            String requestValue = request.getHeader(requestName);
            System.out.println("requestName : "+requestName+" | requestValue : "+requestValue);
        }

        String bearerToken = request.getHeader("Authorization");
        log.info("authorization={}",request.getHeader("Authorization"));
        if (StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}