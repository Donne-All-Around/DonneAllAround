import 'package:a705/transaction_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _valueList = ['최신순', '낮은 가격순'];
  var _selectedValue = '최신순';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Row(
            children: [
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      builder: (BuildContext context) {
                        return Container(
                            height: MediaQuery.of(context).size.height / 5 * 4,
                            color: Colors.transparent,
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 20, 30, 20),
                              height:
                                  MediaQuery.of(context).size.height / 5 * 4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      const Text(
                                        '지역 검색',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      const SizedBox(height: 10),
                                      TextField(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.black87),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: Colors.black87),
                                          ),
                                        ),
                                        cursorColor: Colors.black87,
                                      ),
                                      const SizedBox(height: 20),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '\'역삼동\' 검색 결과',
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                          height: 1, color: Colors.black38),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          color: Color(0xFFFFD954),
                                        ),
                                        child: const Center(
                                            child: Text(
                                          '현재 위치로 찾기',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ],
                              ),
                            ));
                      });
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: const Row(
                    children: [
                      Text(
                        '역삼동',
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      builder: (BuildContext context) {
                        return Container(
                            height: MediaQuery.of(context).size.height / 5 * 4,
                            color: Colors.transparent,
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 20, 30, 20),
                              height:
                                  MediaQuery.of(context).size.height / 5 * 4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      const Text(
                                        '통화 선택',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        height: 50,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          color: Color(0xFFFFD954),
                                        ),
                                        child: const Row(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 20),
                                                CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      'assets/images/australia.png'),
                                                  radius: 10,
                                                ),
                                                SizedBox(width: 10),
                                              ],
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '호주(달러)',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'AUD',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        height: 50,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          color: Color(0xFFFFD954),
                                        ),
                                        child: const Row(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 20),
                                                CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      'assets/images/australia.png'),
                                                  radius: 10,
                                                ),
                                                SizedBox(width: 10),
                                              ],
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '호주(달러)',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'AUD',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ));
                      });
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/australia.png'),
                        radius: 10,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'AUD',
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          leadingWidth: double.infinity,
          actions: [
            IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
                icon: const Icon(Icons.search_rounded, color: Colors.black87)),
            const SizedBox(width: 15),
            IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded,
                    color: Colors.black87)),
            const SizedBox(width: 30),
          ],
        ),
        body: Stack(children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Color(0xFFFFD954),
                    ),
                    child: ExpansionTile(
                        title: const Text(
                          '계산기',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        initiallyExpanded: true,
                        backgroundColor: const Color(0xFFFFD954),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    color: const Color(0xFFD9D9D9),
                                    width: 2,
                                  ),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        value: _selectedValue,
                                        items: _valueList.map((value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(
                                              value,
                                              style:
                                                  const TextStyle(fontSize: 15),
                                              textAlign: TextAlign.end,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedValue = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                                width: double.infinity,
                                height: kMinInteractiveDimension,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border: Border.all(
                                    color: const Color(0xFFD9D9D9),
                                    width: 2,
                                  ),
                                  color: Colors.white,
                                ),
                                child: const Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          AssetImage('assets/images/korea.png'),
                                      radius: 8,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '대한민국(원화) KRW',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _selectedValue,
                        items: _valueList.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: SizedBox(
                              width: 100,
                              child: Text(
                                value,
                                style: const TextStyle(fontSize: 17),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
                const Expanded(child: ListViewBuilder()),
              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const TransactionPage();
                  },
                ));
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFD954),
                ),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

List<String> transactions = ['옹골찬', '김싸피', '박싸피', '정현아', '문요환', '별의 커비', '뽀로로'];

class ListViewBuilder extends StatefulWidget {
  const ListViewBuilder({super.key});

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: transactions.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            width: 20,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 0),
                  ),
                ]),
          );
        });
  }
}
