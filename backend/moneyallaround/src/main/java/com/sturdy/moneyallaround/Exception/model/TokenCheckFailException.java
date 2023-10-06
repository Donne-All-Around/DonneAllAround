package com.sturdy.moneyallaround.Exception.model;

import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;

public class TokenCheckFailException extends RuntimeException{
    public TokenCheckFailException(ExceptionMessage exceptionMessage) {
        super(exceptionMessage.message());
    }
}
