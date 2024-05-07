import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/custom/custom_title_bar.dart';
import 'package:pophub/user/login.dart';

class JoinUser extends StatefulWidget {
  const JoinUser({super.key});

  @override
  State<JoinUser> createState() => _JoinUserState();
}

class _JoinUserState extends State<JoinUser> {
  int selectedValue = 1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(
      children: [
        const CustomTitleBar(titleName: "회원가입"),
        Center(
            child: Container(
                padding: EdgeInsets.all(Constants.DEFAULT_PADDING),
                margin: EdgeInsets.only(top: 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        const Expanded(
                            flex: 2,
                            child: TextField(
                                decoration:
                                    InputDecoration(hintText: "아이디 입력"))),
                        Container(
                          height: 50,
                          width: 90,
                          margin: EdgeInsets.only(left: 10),
                          child: OutlinedButton(
                              onPressed: () => {},
                              child: Container(
                                  child: const Text(
                                "중복 확인",
                                textAlign: TextAlign.center,
                              ))),
                        ),
                      ],
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    const TextField(
                        decoration: InputDecoration(hintText: "비밀번호")),
                    const Spacer(
                      flex: 1,
                    ),
                    const TextField(
                        decoration: InputDecoration(hintText: "비밀번호 재입력")),
                    const Spacer(flex: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: IconButton(
                            padding: EdgeInsets.only(right: 0),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.info_outline,
                              color: Colors.black87,
                              size: 25,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 0),
                          child: Text(
                            "팝업스토어 등록하실 분들은 판매자로 가입부탁드립니다 !",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RadioListTile<int>(
                            title: const Text('사용자'),
                            value: 1,
                            groupValue: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<int>(
                            title: const Text('판매자'),
                            value: 2,
                            groupValue: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 40),
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: OutlinedButton(
                          onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()))
                              },
                          child: const Text("완료")),
                    ),
                  ],
                )))
      ],
    )));
  }
}
