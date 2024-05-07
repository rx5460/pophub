import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/user/join_verify_phone.dart';
import 'assets/style.dart';
import 'user/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: MainPagePage(),
    );
  }
}

class MainPagePage extends StatefulWidget {
  const MainPagePage({super.key});

  @override
  State<MainPagePage> createState() => _MainPagePageState();
}

class _MainPagePageState extends State<MainPagePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Center(
                child: Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(Constants.DEFAULT_PADDING),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo.jpg',
              height: 100,
              width: 100,
            ),
            Text("팝허브와 함께 \n 다양한 팝업스토어 \n 정보를 찾아봐요!",
                textAlign: TextAlign.center),
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(top: 30),
              child: OutlinedButton(
                  onPressed: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()))
                      },
                  child: Text("로그인")),
            ),
            TextButton(
                onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerifyPhone()))
                    },
                child: Text("회원가입"))
          ],
        ),
      ),
    ))));
  }
}
