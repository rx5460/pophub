import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/custom/custom_title_bar.dart';
import 'package:pophub/user/join_user.dart';
import 'package:pophub/user/login.dart';

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
                padding: EdgeInsets.all(Constants.DEFAULT_PADDING),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 70),
                    ),
                    TextField(decoration: InputDecoration(hintText: "아이디 입력")),
                    TextField(
                        decoration: InputDecoration(hintText: "핸드폰 번호 입력")),
                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.only(top: 30),
                      child: OutlinedButton(
                          onPressed: () => {}, child: Text("전송")),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: TextField(
                                decoration:
                                    InputDecoration(hintText: "인증번호 입력"))),
                        Container(
                          width: 80,
                          height: 50,
                          margin:
                              EdgeInsets.only(top: 30, bottom: 30, left: 10),
                          child: OutlinedButton(
                              onPressed: () => {},
                              child: Text(
                                "확인",
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ],
                    ),
                    TextField(decoration: InputDecoration(hintText: "비밀번호 입력")),
                    TextField(
                        decoration: InputDecoration(hintText: "비밀번호 재입력")),
                    Spacer(),
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: OutlinedButton(
                          onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()))
                              },
                          child: Text("비밀번호 변경")),
                    ),
                  ],
                )))
      ],
    )));
  }
}
