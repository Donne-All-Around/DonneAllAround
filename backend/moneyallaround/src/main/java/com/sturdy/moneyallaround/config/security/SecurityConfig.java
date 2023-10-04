package com.sturdy.moneyallaround.config.security;

import com.sturdy.moneyallaround.config.security.jwt.JwtAuthenticationFilter;
import com.sturdy.moneyallaround.config.security.jwt.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Slf4j
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    private final JwtTokenProvider jwtTokenProvider;

    private static final String[] AUTH_WHITELIST = {
            "/api/member/check/nickname",
            "/api/member/check/tel",
            "/api/member/join",
            "/api/member/login",
            "/api/member/verifyFirebaseToken",
            "/api/member/check/nickname"
    };


    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception{
        log.info("filter-chain start!!!");
        http.csrf(AbstractHttpConfigurer::disable);

        http
                .authorizeHttpRequests((authorize) -> authorize
                        .requestMatchers(AUTH_WHITELIST).permitAll()
                        //.requestMatchers(USER_LIST).hasRole("USER")
                        .anyRequest().authenticated()
                )
                .addFilterBefore(new JwtAuthenticationFilter(jwtTokenProvider), UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }

    //SpringSecurity 가 swagger 에서 할때는 적용안되는 예외 코드
    @Bean
    public WebSecurityCustomizer webSecurityCustomizer(){
        return (web) -> web.ignoring().requestMatchers("/v3/api-docs/**", "/swagger-ui/**", "/api-docs/json/**");
    }


}
