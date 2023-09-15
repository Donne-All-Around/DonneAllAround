import 'package:a705/profile_page.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:a705/calculate_page.dart';
import 'package:a705/chatting_page.dart';
import 'package:a705/exchange_page.dart';
import 'package:a705/home_page.dart';

const List<TabItem> items = [
  TabItem(
    icon: Icons.home_outlined,
    title: '홈',
  ),
  TabItem(
    icon: Icons.money,
    title: '환율',
  ),
  TabItem(
    icon: Icons.calculate_outlined,
    title: '계산',
  ),
  TabItem(
    icon: Icons.chat_bubble_outline_rounded,
    title: '채팅',
  ),
  TabItem(
    icon: Icons.person_outlined,
    title: '내 정보',
  ),
];

class MainPage extends StatefulWidget {

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigationBar(
      ),
    );
  }
}

class BottomNavigationBar extends StatefulWidget {

  const BottomNavigationBar({super.key});

  @override
  State<BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  int visit = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: _page[visit],
          bottomNavigationBar: BottomBarBackground(
            items: items,
            backgroundColor: Colors.white,
            color: Colors.black87,
            colorSelected: Colors.purple,
            backgroundSelected: Colors.black12,
            indexSelected: visit,
            onTap: (int index) => setState(() {
              visit = index;
            }),
          ),
        ));
  }
}

final List<Widget> _page = [
  const HomePage(),
  const ExchangePage(),
  const CalculatePage(),
  const ChattingPage(),
  const ProfilePage(),
];
