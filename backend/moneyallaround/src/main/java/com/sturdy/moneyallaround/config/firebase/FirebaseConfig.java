package com.sturdy.moneyallaround.config.firebase;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.messaging.FirebaseMessaging;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.List;

@Slf4j
@Configuration
public class FirebaseConfig {
    //@Value("${fcm.service-account-file}")
    private String serviceAccountFilePath
            = "src/main/resources/firebase/donnearound-java-access-key.json";

    private String scope = "https://www.googleapis.com/auth/cloud-platform";

    @Bean
    public FirebaseApp firebaseApp() throws IOException {
        FileInputStream token = new FileInputStream(serviceAccountFilePath);
        FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(token))
                .setDatabaseUrl("https://donnearroundfirebase.firebaseio.com")
                .build();

        FirebaseApp firebaseApp = FirebaseApp.initializeApp(options);
        log.info(firebaseApp.getName());
        return firebaseApp;
    }

    @Bean
    public FirebaseAuth initFirebaseAuth() throws IOException {
        return FirebaseAuth.getInstance(firebaseApp());
    }

    @Bean
    public FirebaseMessaging initFirebaseMessaging() throws IOException {
        return FirebaseMessaging.getInstance(firebaseApp());
    }
}