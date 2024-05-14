import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/utils/log.dart';
import 'assets/style.dart';
import 'screen/user/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Logger.setLogLevel(LogLevel.debug); // 로그 레벨 설정
    Logger.debug('APP start ! ');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demoasd',
      theme: theme,
      home: const MainPagePage(),
    );
  }
}

class MainPagePage extends StatefulWidget {
  const MainPagePage({super.key});

  @override
  State<MainPagePage> createState() => _MainPagePageState();
}

class _MainPagePageState extends State<MainPagePage> {
  // TODO 김영수 : 앱 시작시 메인 페이지로 이동하게
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Center(
                child: Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Constants.DEFAULT_PADDING),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 100,
              width: 100,
            ),
            Container(
              width: double.infinity,
              height: 55,
              margin: const EdgeInsets.only(top: 30),
              child: OutlinedButton(
                  onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()))
                      },
                  child: const Text("로그인")),
            ),
          ],
        ),
      ),
    ))));
  }
}
