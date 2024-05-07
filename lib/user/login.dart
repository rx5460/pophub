import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/custom/custom_title_bar.dart';
import 'package:pophub/user/find_id.dart';
import 'package:pophub/user/reset_passwd.dart';

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
            body: Stack(children: [
      const CustomTitleBar(titleName: "로그인"),
      Center(
        child: Padding(
            // width: double.infinity,
            padding: EdgeInsets.all(Constants.DEFAULT_PADDING),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/img/logo.jpg',
                  height: 100,
                  width: 100,
                ),
                TextField(decoration: InputDecoration(hintText: "아이디")),
                TextField(decoration: InputDecoration(hintText: "비밀번호")),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.only(top: 30, bottom: 30),
                  child:
                      OutlinedButton(onPressed: () => {}, child: Text("로그인")),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FindId()))
                            },
                        child: Text("아이디 찾기")),
                    TextButton(
                        onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResetPasswd()))
                            },
                        child: Text("비밀번호 찾기")),
                  ],
                )
              ],
            )),
      )
    ])));
  }
}
