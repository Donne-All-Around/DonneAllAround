package com.sturdy.moneyallaround.Exception.model;

import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;

public class SmsAuthenticationException extends RuntimeException {

    public SmsAuthenticationException(String error){super(error);}

    public SmsAuthenticationException(ExceptionMessage exceptionMessage){
        super(exceptionMessage.message());
    }
}
