import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/custom/custom_title_bar.dart';
import 'package:pophub/user/join_user.dart';
import 'package:pophub/user/login.dart';

class VerifyPhone extends StatefulWidget {
  const VerifyPhone({super.key});

  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(
      children: [
        const CustomTitleBar(titleName: "휴대폰 본인 인증"),
        Center(
            child: Padding(
                padding: EdgeInsets.all(Constants.DEFAULT_PADDING),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 70),
                      child: Text(
                        "도용 방지를 위해\n본인 인증을 완료해주세요!",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
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
                    Spacer(),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                          onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => JoinUser()))
                              },
                          child: Text("완료")),
                    ),
                  ],
                )))
      ],
    )));
  }
}
