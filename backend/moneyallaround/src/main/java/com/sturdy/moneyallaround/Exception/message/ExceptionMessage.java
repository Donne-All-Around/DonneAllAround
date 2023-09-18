package com.sturdy.moneyallaround.Exception.message;

public enum ExceptionMessage {

    SMS_NOT_FOUND("전화번호를 찾을 수 없습니다.");

    private final String message;

    ExceptionMessage(String message) {this.message = message;}

    public String message(){ return message;}
}
