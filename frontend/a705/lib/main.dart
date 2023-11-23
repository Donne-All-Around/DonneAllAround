import 'package:a705/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:a705/providers/member_providers.dart';
import 'package:provider/provider.dart';
import 'package:a705/Login/login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'Login/profilesetting_page.dart';
import 'Login/start_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 바인딩
  await Firebase.initializeApp();
  // interceptor ?
  await dotenv.load(fileName: 'assets/config/.env');
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(), // UserProvider 초기화
      child: const MyApp(),
    ),
  );

}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      routes: {
        '/login': (context) => LoginPage(),
        // 다른 경로도 필요하면 추가하세요.
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFFFFD954),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      locale: const Locale('ko'),
      // home: ProfileSettingPage(phoneNumber: '01063139114', uid: 'jtBaAfz6KEPOXzZoB97VS4FRWap2'),
      // home: const StartPage(),
      home: const MainPage(),
      // home: ProfileSettingPage(phoneNumber: '01010251025', uid: 'zV0RDTa0CXPW2A5i0wyyvdCZVYr2'),
    );
  }
}
