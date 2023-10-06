package com.sturdy.moneyallaround.Exception.model;

import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;

public class TokenNotFoundException extends RuntimeException{
    public TokenNotFoundException(ExceptionMessage exceptionMessage) {
        super(exceptionMessage.message());
    }
}
