package com.sturdy.moneyallaround.Exception.handler;

import com.sturdy.moneyallaround.Exception.dto.ExceptionDto;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
@Slf4j
public class ExceptionHandlerAdvice {
    @ExceptionHandler(value = Exception.class)
    public ResponseEntity<ExceptionDto> exceptionHandler(Exception exception, Model model, HttpServletResponse httpServletResponse) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ExceptionDto.builder().statusCode(String.valueOf(HttpServletResponse.SC_INTERNAL_SERVER_ERROR))
                        .message(String.format("%s", exception.getMessage()))
                        .build());
    }
}
