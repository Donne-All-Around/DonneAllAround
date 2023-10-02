package com.sturdy.moneyallaround.config.firebase;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import okhttp3.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class FCMService {
    @Value("${fcm.service-account-file}")
    private String serviceAccountFilePath;

    private String API_URL = "https://fcm.googleapis.com/v1/projects/donnearound/messages:send";

    private final ObjectMapper objectMapper;

    /*
        두 버전 테스트 후 확정
     */

    /*
        단체 알림 전송 ver
     */

    public void sendMulticastMessageTo(String title, String body, List<String> tokenList) throws IOException, FirebaseMessagingException {
        MulticastMessage message = MulticastMessage.builder()
                .putData("fcm_type", "NOTIFICATION")
                .putData("title", title)
                .putData("body", body)
                .addAllTokens(tokenList)
                .build();

        BatchResponse response = FirebaseMessaging.getInstance().sendMulticast(message);

        failMessage(tokenList, response);
    }

    // 토큰이 유효하지 않아 fcm 발송이 실패한 데이터 추출
    private void failMessage(List<String> mergeTokenList, BatchResponse response) {
        if (response.getFailureCount() > 0) {
            List<SendResponse> responses = response.getResponses();
            List<String> failedTokens = new ArrayList<>();

            for (int i = 0; i < responses.size(); i++) {
                if (!responses.get(i).isSuccessful()) {
                    failedTokens.add(mergeTokenList.get(i));
                }
            }

            log.info("======================= failedTokens : " + failedTokens + "=======================(추후 실패한 토큰은 삭제 시켜줘야함) -> 쓸데없는 알람이 가서 성능 저하를 일으킴");
        }
        log.info("======================= Success : " + response + "=======================");
    }

    /*
        단일 알림 전송 ver
     */
    private String getAccessToken() throws IOException {
        GoogleCredentials googleCredentials = GoogleCredentials
                .fromStream(new ClassPathResource(serviceAccountFilePath).getInputStream())
                .createScoped(List.of("https://www.googleapis.com/auth/cloud-platform"));

        googleCredentials.refreshIfExpired();
        return googleCredentials.getAccessToken().getTokenValue();
    }

    public String makeMessage(String targetToken, String title, String body) throws JsonProcessingException, JsonParseException {
        FCMMessage fcmMessage = FCMMessage.builder()
                .message(
                        FCMMessage.Message.builder()
                                .token(targetToken)
                                .notification(
                                        FCMMessage.Notification.builder()
                                                .title(title)
                                                .body(body)
                                                .build()
                                )
                                .build()
                )
                .validateOnly(false)
                .build();

        return objectMapper.writeValueAsString(fcmMessage);
    }

    public void sendMessageTo(String targetToken, String title, String body) throws IOException {
        String message = makeMessage(targetToken, title, body);

        OkHttpClient client = new OkHttpClient();
        RequestBody requestBody = RequestBody.create(message, MediaType.get("application/json; charset=utf-8"));

        Request request = new Request.Builder()
                .url(API_URL)
                .post(requestBody)
                .addHeader(HttpHeaders.AUTHORIZATION, "Bearer " + getAccessToken())
                .addHeader(HttpHeaders.CONTENT_TYPE, "application/json; UTF-8")
                .build();

        Response response = client.newCall(request).execute();
    }
}
