import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: const BoxDecoration(
                color: Color(0xFFFFD954),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  // 상단부분: 프로필 사진과 닉네임
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                            // image: DecoraionImage(
                              // image: AssetImage('assets/profile_image.jpg'),
                              // fit: BoxFit.cover,
                            // )
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        // 닉네임
                        const Text(
                          '닉네임',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 중단 부분 : 버튼들
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // '내 주머니' 버튼 클릭 시 동작
                          },
                          child: const Text('내 주머니'),
                        ),
                        const SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            // '내 계좌' 버튼 클릭 시 동작
                          },
                          child: const Text('내 계좌'),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '여기에 값 표시',
                      style: TextStyle(fontSize: 24.0),
                    )
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
              height: 210,
              width: 360,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "나의 거래",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Inter",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  InkWell(
                    //onTap: () {
                  //    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                  //  },
                    child: Container(
                      height: 35.0,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "관심 목록",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Inter",
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    // onTap: (){
                    //  Navigator.push
                    // },
                    child: Container(
                      height: 35.0,
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.receipt,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                                "판매 내역",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Inter",
                                  fontSize: 15.0,
                                )
                            )
                          ]
                      )
                    )
                  ),
                  InkWell(
                  //   onTap: (){
                  //    Navigator.push
                  //  },
                    child: Container(
                      height:35.0,
                      child: const Row (
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.shopping_bag,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "구매 내역",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Inter",
                              fontSize: 15.0,
                            )
                          )
                        ]
                      )
                    )
                  ),
                  InkWell(
                  //   onTap: (){
                  //    Navigator.push
                  //  },
                    child: Container(
                      height: 35.0,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.fact_check,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "나의 후기",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Inter",
                              fontSize: 15.0,
                            )
                          )
                        ]
                      )
                    )
                  )
                ]
              )
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
              height: 105,
              width: 360,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "나의 환전",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Inter",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  InkWell(
                  //  onTap: (){
                  //    Navigator.push(context,MaterialPageRoute(builder: (context) => MainPage()));
                  //  },
                    child: Container(
                      height: 35.0,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.edit,
                          ),
                          SizedBox(width:8.0),
                          Text(
                            "환전 기록",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Inter",
                              fontSize: 15.0
                            )
                          )
                        ]
                      )
                    )
                  )
                ]
              )
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
              height: 140,
              width: 360,
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Align(
                    alignment:Alignment.centerLeft,
                    child: Text(
                      "나의 키워드",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Inter",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  InkWell(
                    // onTap: () {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                    // },
                    child: Container(
                      height: 35.0,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.person,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "거래",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Inter",
                              fontSize: 15.0,
                            )
                          )
                        ]
                      ),
                    ),
                  ),
                  InkWell(
                  //  onTap: () {
                  //    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                  //  },
                    child: Container(
                      height: 35.0,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.monetization_on,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "환율",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Inter",
                              fontSize: 15.0,
                              )
                          )
                        ]
                      ),
                    ),
                  )
                ]
              )
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
              height: 140,
              width: 360,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "사용자 설정",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Inter",
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  InkWell(
                    //  onTap: () {
                    //    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                    //  },
                    child: Container(
                      height: 35.0,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.logout
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "로그아웃",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Inter",
                              fontSize: 15.0
                            )
                          )
                        ]
                      ),
                    ),
                  ),
                  InkWell(
                  //  onTap: () {
                  //    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                  //  },
                    child: Container(
                      height: 35.0,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.delete
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "회원 탈퇴",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Inter",
                              fontSize: 15.0
                            )
                          )
                        ]
                      )
                    )
                  )
                ]
              )
            )
          ]
        )
      )
    );
  }
}
