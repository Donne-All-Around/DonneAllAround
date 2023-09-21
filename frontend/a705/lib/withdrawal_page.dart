import 'package:flutter/material.dart';

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({super.key});

  @override
  State<WithdrawalPage> createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
              iconSize: 50,
            ),
            const SizedBox(height: 30.0),
            const Center(
              child: Text(
                '탈퇴하기',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                )
              )
            ),
            const SizedBox(height: 25.0),
            const Center(
              child: Text(
                '잠깐! 돈네한바퀴를 탈퇴하기 전에',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey
                )
              )
            ),
            const Center(
              child: Text(
                '아래 정보를 확인해주세요',
                style: TextStyle(
                  fontSize: 18.0,
                    color: Colors.grey
                )
              )
            ),
            const SizedBox(height: 60.0),
            Center(
              child: Container(
                width: 350.0,
                height: 120.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFECA8),
                  borderRadius: BorderRadius.circular(20.0)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          '작성된 모든 정보가 삭제 돼요',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '😱',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.yellow
                          )
                        )
                      ]
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      '모든 게시글 및 채팅방이 삭제돼요.',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '매너 온도와 거래 후기 등 모든 활동 정보가 삭제되며',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '계정을 다시 살리거나 재가입 후 데이터를 복구할 수 없어요.',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ]
                )
              )
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Container(
                width: 350.0,
                height: 120.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFECA8),
                  borderRadius: BorderRadius.circular(20.0)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          '처음부터 다시 가입해야 해요',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '😥',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.yellow,
                          )
                        )
                      ]
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      '탈퇴 회원의 정보는 15일간 임시 보관 후 완벽히 삭제돼요.',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '탈퇴하시면 회원가입부터 다시 진행해야해요.',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ]
                )
              )
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Container(
                width: 350.0,
                height: 120.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFECA8),
                  borderRadius: BorderRadius.circular(20.0)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          '하나하나 다시 연동해야해요.',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '💰',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.yellow,
                          )
                        )
                      ]
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      '탈퇴 후에는 연동된 결제 수단과 포인트 정보가 삭제돼요.',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '카드 등 사용중인 결제 수단을 처음부터 다시 연동해야 해요.',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ]
                )
              )
            ),
            const SizedBox(height: 50.0),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 회원탈퇴 로직
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      fixedSize: const Size(160.0, 50.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0), // radius 10 설정
                      ),
                    ),
                    child: const Text(
                      '계정 삭제',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 30.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      fixedSize: const Size(160.0, 50.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0), // radius 10 설정
                      ),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )
                  )
                ]
              )
            )
          ],
        )
      ),
    );
  }
}