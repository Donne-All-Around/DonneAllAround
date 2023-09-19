package com.sturdy.moneyallaround.common.api;

import lombok.RequiredArgsConstructor;

import java.util.Map;

@RequiredArgsConstructor
public class ApiResponse<T> {
    private final ApiStatus status;
    private final String message;
    private final T data;

    public static <T> ApiResponse<T> success(String message, T data) {
        return new ApiResponse<>(ApiStatus.SUCCESS, message, data);
    }

    public static ApiResponse<Object> fail(String message) {
        return new ApiResponse<>(ApiStatus.FAIL, message, null);
    }
}
