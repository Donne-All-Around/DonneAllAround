package com.sturdy.moneyallaround.common;

public record ApiResponse(

        ApiStatus status,

        String message,

        Object data
) {
    //data 는 실제 API 응답 데이터를 저장하는 객체
    public static ApiResponse success(Object data) {
        return new ApiResponse(ApiStatus.SUCCESS, null, data);
    }

    public static ApiResponse error(String message) {
        return new ApiResponse(ApiStatus.ERROR, message, null);
    }

}
