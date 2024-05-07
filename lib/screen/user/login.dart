import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/notifier/UserNotifier.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/user/find_id.dart';
import 'package:pophub/screen/user/join_verify_phone.dart';
import 'package:pophub/screen/user/reset_passwd.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(children: [
              const CustomTitleBar(titleName: "로그인"),
              Center(
                child: Padding(
                    // width: double.infinity,
                    padding: const EdgeInsets.all(Constants.DEFAULT_PADDING),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/img/logo.jpg',
                          height: 150,
                          width: 150,
                        ),
                        const TextField(
                            decoration: InputDecoration(hintText: "아이디")),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                        ),
                        const TextField(
                            decoration: InputDecoration(hintText: "비밀번호")),
                        Container(
                          margin: const EdgeInsets.only(top: 0, bottom: 10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const FindId()))
                                    },
                                child: const Text("아이디 찾기")),
                            TextButton(
                                onPressed: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ResetPasswd()))
                                    },
                                child: const Text("비밀번호 찾기")),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: OutlinedButton(
                              onPressed: () => {}, child: const Text("로그인")),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text("계정이 없으신가요?"),
                            TextButton(
                                onPressed: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MultiProvider(
                                                      providers: [
                                                        ChangeNotifierProvider(
                                                            create: (_) =>
                                                                UserNotifier())
                                                      ],
                                                      child:
                                                          const VerifyPhone())))
                                    },
                                child: const Text(
                                  "회원가입",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ],
                    )),
              )
            ])));
  }
}
