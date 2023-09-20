import 'package:flutter/material.dart';
import 'exchange_record_create_page.dart';

class ExchangeRecordPage extends StatefulWidget {
  const ExchangeRecordPage({super.key});

  @override
  State<ExchangeRecordPage> createState() => ExchangeRecordPageState();
}

// 수정, 삭제 모달
class CustomModalWidget extends StatelessWidget {
  const CustomModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      content: Container(
        width: 330,
        height: 170,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 28,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
                )
              ]
            ),
            const SizedBox(height: 5),
            InkWell(
              onTap: () {
                // 수정하기 동작 구현
              },
              child: Container(
                width: 270,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: const Color(0xFF1D77E8)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "수정하기",
                    style: TextStyle(
                      color: Color(0xFF1D77E8),
                      fontWeight: FontWeight.bold
                    )
                  ),
                )
              )
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: () {
                // 삭제하기 동작 구현
              },
              child: Container(
                width: 270,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: const Color(0xFFF53C3C)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "삭제하기",
                    style: TextStyle(
                      color: Color(0xFFF53C3C),
                      fontWeight: FontWeight.bold
                    )
                  ),
                )
              )
            )
          ]
        )
      )
    );
  }
}



class ExchangeRecordPageState extends State<ExchangeRecordPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.black
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }
          ),
          elevation: 0,
          title: const Text(
            '나의 환전',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '2022년 2월',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      )
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 350,
                      height: 125,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.0),
                        color: const Color(0xFFF2F2F2),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '2022년 9월 20일 수요일',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const CustomModalWidget();
                                      }
                                    );
                                  }
                                )
                              ]
                            )
                          ),
                        ]
                      )
                    )
                  ]
                )
              )
            ]
          )
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFFD954),
            borderRadius: BorderRadius.circular(40),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExchangeRecordCreatePage()));
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                SizedBox(width: 4),
                Text(
                  '추가하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}