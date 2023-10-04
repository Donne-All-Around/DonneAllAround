package com.sturdy.moneyallaround.config.security.jwt;

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
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Arrays;
import java.util.Enumeration;

@Slf4j
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    private final TokenProvider tokenProvider;

    private static final String[] AUTH_WHITELIST = {
            "/api/member/check/nickname",
            "/api/member/check/tel",
            "/api/member/sign-in",
            "/api/member/join",
            "/api/member/logout"
    };

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        logRequest(request);

        if (Arrays.asList(AUTH_WHITELIST).contains(request.getRequestURI())) {
            log.info("AUTH_WHITELIST - 권한 허가");

            filterChain.doFilter(request, response);
            return;
        }

        String token = resolveAccessToken(request);
        log.info("headerToken = {}", token);

        if (request.getRequestURI().equals("/api/member/reissue") || (token != null && tokenProvider.validateToken(token))) {
            log.info("유효한 토큰입니다.");

            Authentication authentication = tokenProvider.getAuthentication(token);

            log.info("authentication = {}", authentication.toString());
            SecurityContextHolder.getContext().setAuthentication(authentication);
        } else {
            log.error("유효하지 않은 토큰입니다.");
            throw new TokenCheckFailException(ExceptionMessage.FAIL_TOKEN_CHECK);
        }

        log.info("권한 확인 완료");
        filterChain.doFilter(request, response);
    }

    private void logRequest(HttpServletRequest request) {
        log.info(String.format(
                "[%s] %s %s",
                request.getMethod(),
                request.getRequestURI().toLowerCase(),
                request.getQueryString() == null ? "" : request.getQueryString())
        );
    }

    private String resolveAccessToken(HttpServletRequest request) {
        log.info("[resolveAccessToken]");
        log.info("headers = {}", request.getHeaderNames());

        Enumeration<String> eHeader = request.getHeaderNames();
        while(eHeader.hasMoreElements()){
            String requestName = eHeader.nextElement();
            String requestValue = request.getHeader(requestName);
            log.info("requestName : "+requestName+" | requestValue : "+requestValue);
        }

        String bearerToken = request.getHeader("Authorization");
        log.info("authorization = {}", bearerToken);
        if(StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer")) {
            return bearerToken.substring(7);
        }

        return null;
    }
}
