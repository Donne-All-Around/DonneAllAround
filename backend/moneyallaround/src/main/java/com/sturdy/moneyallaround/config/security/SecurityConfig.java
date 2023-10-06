package com.sturdy.moneyallaround.config.security;

import com.sturdy.moneyallaround.config.security.jwt.JwtAuthenticationFilter;
import com.sturdy.moneyallaround.config.security.jwt.TokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    private final TokenProvider tokenProvider;

    private static final String[] AUTH_WHITELIST = {
            "/api/member/check/nickname",
            "/api/member/check/tel",
            "/api/member/join",
            "/api/member/sign-in",
            "/api/exchange/token"
    };

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity httpSecurity) throws Exception {
        httpSecurity.csrf(AbstractHttpConfigurer::disable);

        httpSecurity
                .cors(Customizer.withDefaults())
                .authorizeHttpRequests(authorize -> authorize
                        .requestMatchers(AUTH_WHITELIST).permitAll()
                        .anyRequest().authenticated()
                )
                .addFilterBefore(new JwtAuthenticationFilter(tokenProvider), UsernamePasswordAuthenticationFilter.class);

        return httpSecurity.build();
    }
}
