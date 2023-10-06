package com.sturdy.moneyallaround.domain.member.dto.request;

public record FirebaseAuthRequest(String idToken,
                                  String uid,
                                  String tel,
                                  String deviceToken) {
}
