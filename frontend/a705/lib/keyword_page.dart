import 'package:flutter/material.dart';
import 'keyword_create_page.dart';

class Keyword {
  final String countryCurrency;
  final String location;
  final String flagImageUrl;

  Keyword({
    required this.countryCurrency,
    required this.location,
    required this.flagImageUrl,
  });
}


class KeywordPage extends StatefulWidget {
  const KeywordPage({super.key});

  @override
  State<KeywordPage> createState() => KeywordPageState();
}

class KeywordPageState extends State<KeywordPage> {

  // 가상의 키워드 데이터 목록
  final List<Keyword> keywords = [
    Keyword(
      countryCurrency: '호주(달러) AUD',
      location: '서울특별시 강서구 화곡동',
      flagImageUrl: 'assets/images/AUD.png',
    ),
    Keyword(
      countryCurrency: '호주(달러) AUD',
      location: '서울특별시 강서구 화곡동',
      flagImageUrl: 'assets/images/AUD.png',
    ),
    Keyword(
      countryCurrency: '호주(달러) AUD',
      location: '서울특별시 강서구 화곡동',
      flagImageUrl: 'assets/images/AUD.png',
    ),
    Keyword(
      countryCurrency: '호주(달러) AUD',
      location: '서울특별시 강서구 화곡동',
      flagImageUrl: 'assets/images/AUD.png',
    ),
    Keyword(
      countryCurrency: '호주(달러) AUD',
      location: '서울특별시 강서구 화곡동',
      flagImageUrl: 'assets/images/AUD.png',
    ),
    Keyword(
      countryCurrency: '호주(달러) AUD',
      location: '서울특별시 강서구 화곡동',
      flagImageUrl: 'assets/images/AUD.png',
    ),
    Keyword(
      countryCurrency: '호주(달러) AUD',
      location: '서울특별시 강서구 화곡동',
      flagImageUrl: 'assets/images/AUD.png',
    ),
    Keyword(
      countryCurrency: '호주(달러) AUD',
      location: '서울특별시 강서구 화곡동',
      flagImageUrl: 'assets/images/AUD.png',
    ),
    Keyword(
      countryCurrency: '호주(달러) AUD',
      location: '서울특별시 강서구 화곡동',
      flagImageUrl: 'assets/images/AUD.png',
    ),
    Keyword(
      countryCurrency: '호주(달러) AUD',
      location: '서울특별시 강서구 화곡동',
      flagImageUrl: 'assets/images/AUD.png',
    ),
  ];

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
            '나의 키워드',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )
          ),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: keywords.length,
          itemBuilder: (context, index) {
            final keyword = keywords[index];
            return Container(
              width: 350,
              height: 80,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
                    child: Image.asset(
                      keyword.flagImageUrl,
                      width: 40,
                      height: 40,
                    )
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                keyword.countryCurrency,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right
                            ),
                            const SizedBox(height:5),
                            Text(
                                keyword.location,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.right
                            )
                          ]
                        )
                      )
                    )
                  )
                ]
              )
            );
          }
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
              if (keywords.length < 10) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KeywordCreatePage()));
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text('키워드는 10개까지만 등록이 가능합니다'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('확인')
                        )
                      ]
                    );
                  }
                );
              }
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