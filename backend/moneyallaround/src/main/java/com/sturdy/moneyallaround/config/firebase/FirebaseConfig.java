package com.sturdy.moneyallaround.config.firebase;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import java.io.FileInputStream;
import java.io.IOException;

@Configuration
public class FirebaseConfig {
    @Value("${fcm.service-account-file}")
    private String serviceAccountFilePath;

//    @PostConstruct
//    public void init() throws IOException {
//        FileInputStream token = new FileInputStream(serviceAccountFilePath);
//        FirebaseOptions options = FirebaseOptions.builder()
//                .setCredentials(GoogleCredentials.fromStream(token))
//                .build();
//        FirebaseApp.initializeApp(options);
//    }
}
