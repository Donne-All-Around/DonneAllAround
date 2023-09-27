package com.sturdy.moneyallaround.Exception.model;

import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;

public class TokenNotFoundException extends RuntimeException {

    public TokenNotFoundException(String error) {super(error);} //super는 부모 클래스의 생성자나 멤버를 호출할 때 사용

    public TokenNotFoundException(ExceptionMessage exceptionMessage) {super(exceptionMessage.message());}
}
