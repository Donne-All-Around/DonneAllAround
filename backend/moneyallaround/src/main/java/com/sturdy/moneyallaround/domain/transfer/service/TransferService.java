package com.sturdy.moneyallaround.domain.transfer.service;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.WriteResult;
import com.google.firebase.cloud.FirestoreClient;
import com.sturdy.moneyallaround.config.firebase.FCMService;
import com.sturdy.moneyallaround.domain.member.service.MemberService;
import com.sturdy.moneyallaround.domain.trade.service.TradeService;
import com.sturdy.moneyallaround.domain.transfer.dto.request.TransferRequestDto;
import com.sturdy.moneyallaround.domain.transfer.entity.Transfer;
import com.sturdy.moneyallaround.domain.transfer.repository.TransferRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.List;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class TransferService {
    private final TransferRepository transferRepository;
    private final MemberService memberService;
    private final TradeService tradeService;
    private final FCMService fcmService;

    @Transactional
    public void transfer(String memberTel, TransferRequestDto transferRequestDto) {
        transferRepository.save(transferRequestDto.toTransfer(tradeService.findTrade(transferRequestDto.tradeId())));
        memberService.remittance(memberService.findByTel(memberTel).getId(), transferRequestDto.amount());
    }

    @Transactional
    public void cancelTransfer(Long tradeId) {
        Transfer transfer = findByTradeId(tradeId);
        memberService.deposit(transfer.getTrade().getBuyer().getId(), transfer.getAmount());
        transferRepository.deleteById(transfer.getId());
    }

    @Transactional
    public void deposit(Long tradeId) {
        Transfer transfer = findByTradeId(tradeId);
        memberService.deposit(transfer.getTrade().getSeller().getId(), transfer.getAmount());
        transferRepository.deleteById(transfer.getId());
    }

    public Transfer findByTradeId(Long tradeId) {
        return transferRepository.findByTradeId(tradeId);
    }

    public Boolean existsTransfer(Long tradeId) {
        return transferRepository.existsByTradeId(tradeId);
    }

//    @Scheduled(cron = "0 0 0 * * *")
//    @Transactional
//    public void checkTransfer() {
//        List<Transfer> transferList = transferRepository.findByCreatedTime();
//        transferList.forEach(transfer -> {
//            memberService.deposit(transfer.getTrade().getSeller().getId(), transfer.getAmount());
//            tradeService.completePromise(transfer.getTrade().getId());
//            transferRepository.deleteById(transfer.getId());
//
////            /*
////                firebase 내 채팅 메세지 생성
////             */
////            StringBuilder documentName = new StringBuilder();
////            documentName.append(transfer.getTrade().getId()).append("_")
////                    .append(transfer.getTrade().getSeller().getId()).append("_")
////                    .append(transfer.getTrade().getBuyer().getId());
////
////            Firestore db = FirestoreClient.getFirestore();
////            ApiFuture<WriteResult> collectionApiFuture =
////                    db.collection("chatrooms")
////                            .document(documentName.toString())
////                            .collection("chats")
////
////
//
//            /*
//                전화번호가 아닌 토큰으로 변경 필요
//             */
//            StringBuilder body = new StringBuilder();
//            body.append("[입금 알림] ");
//
//            String tradeTitle = transfer.getTrade().getTitle();
//            if (tradeTitle.length() <= 5) {
//                body.append(tradeTitle);
//            } else {
//                body.append(tradeTitle, 0, 5).append("...");
//            }
//
//            body.append("건 ").append(transfer.getAmount()).append("원 입금");
//
//            try {
//                fcmService.sendMessageTo(transfer.getTrade().getSeller().getTel(), "돈네한바퀴", body.toString());
//            } catch (IOException e) {
//                log.error(e.getMessage());
//            }
//        });
//    }
}
