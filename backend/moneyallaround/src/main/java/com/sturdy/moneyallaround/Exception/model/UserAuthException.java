package com.sturdy.moneyallaround.Exception.model;

import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;

public class UserAuthException extends RuntimeException{

    public UserAuthException(String error) {super(error);}

    public UserAuthException(ExceptionMessage exceptionMessage) {super(exceptionMessage.message());}
}
