package com.sturdy.moneyallaround.domain.transfer.service;

import com.sturdy.moneyallaround.domain.member.service.MemberService;
import com.sturdy.moneyallaround.domain.trade.service.TradeService;
import com.sturdy.moneyallaround.domain.transfer.dto.request.TransferRequestDto;
import com.sturdy.moneyallaround.domain.transfer.entity.Transfer;
import com.sturdy.moneyallaround.domain.transfer.repository.TransferRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class TransferService {
    private final TransferRepository transferRepository;
    private final MemberService memberService;
    private final TradeService tradeService;

    @Transactional
    public void transfer(Long memberId, TransferRequestDto transferRequestDto) {
        transferRepository.save(transferRequestDto.toTransfer(tradeService.findTrade(transferRequestDto.tradeId())));
        memberService.remittance(memberId, transferRequestDto.amount());
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
}
