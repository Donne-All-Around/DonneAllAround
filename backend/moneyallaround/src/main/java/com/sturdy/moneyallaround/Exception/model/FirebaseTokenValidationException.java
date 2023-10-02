package com.sturdy.moneyallaround.Exception.model;

import com.sturdy.moneyallaround.Exception.message.ExceptionMessage;

public class FirebaseTokenValidationException extends RuntimeException{

	public FirebaseTokenValidationException(String error){super(error);}

	public FirebaseTokenValidationException(ExceptionMessage exceptionMessage){super(exceptionMessage.message());}
}
