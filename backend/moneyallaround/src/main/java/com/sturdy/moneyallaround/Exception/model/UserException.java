package com.sturdy.moneyallaround.Exception.model;

import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;

public class UserException extends RuntimeException {

    public UserException(String error){super(error);}

    public UserException(ExceptionMessage exceptionMessage){
        super(exceptionMessage.message());
    }
}
