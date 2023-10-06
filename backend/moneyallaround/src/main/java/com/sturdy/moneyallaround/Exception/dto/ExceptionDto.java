package com.sturdy.moneyallaround.Exception.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ExceptionDto {
    private final String message;
    public final String statusCode;
}
