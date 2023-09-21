import 'package:firebase_core/firebase_core.dart';
import 'package:a705/Login/start_page.dart';
import 'package:flutter/material.dart';
import 'main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 바인딩
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFFFFD954),
      ),
      home: const StartPage(),
    );
  }
}
