import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/user/login.dart';

class ResetPasswd extends StatefulWidget {
  const ResetPasswd({super.key});

  @override
  State<ResetPasswd> createState() => _ResetPasswdState();
}

class _ResetPasswdState extends State<ResetPasswd> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(
      children: [
        const CustomTitleBar(titleName: "비밀번호 재설정"),
        Center(
            child: Padding(
                padding: const EdgeInsets.all(Constants.DEFAULT_PADDING),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 70),
                    ),
                    const TextField(
                        decoration: InputDecoration(hintText: "아이디 입력")),
                    const TextField(
                        decoration: InputDecoration(hintText: "핸드폰 번호 입력")),
                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.only(top: 30),
                      child: OutlinedButton(
                          onPressed: () => {}, child: const Text("전송")),
                    ),
                    Row(
                      children: [
                        const Expanded(
                            child: TextField(
                                decoration:
                                    InputDecoration(hintText: "인증번호 입력"))),
                        Container(
                          width: 80,
                          height: 50,
                          margin: const EdgeInsets.only(
                              top: 30, bottom: 30, left: 10),
                          child: OutlinedButton(
                              onPressed: () => {},
                              child: const Text(
                                "확인",
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ],
                    ),
                    const TextField(
                        decoration: InputDecoration(hintText: "비밀번호 입력")),
                    const TextField(
                        decoration: InputDecoration(hintText: "비밀번호 재입력")),
                    const Spacer(),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: OutlinedButton(
                          onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()))
                              },
                          child: const Text("비밀번호 변경")),
                    ),
                  ],
                )))
      ],
    )));
  }
}
