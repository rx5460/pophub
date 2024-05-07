import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/notifier/UserNotifier.dart';
import 'package:pophub/screen/custom/custom_text_form_feild.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/user/login.dart';
import 'package:pophub/utils/utils.dart';

class JoinUser extends StatefulWidget {
  const JoinUser({super.key});

  @override
  State<JoinUser> createState() => _JoinUserState();
}

class _JoinUserState extends State<JoinUser> {
  int selectedValue = 1;
  final _idFormkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(
      children: [
        const CustomTitleBar(titleName: "회원가입"),
        Center(
            child: Container(
                padding: const EdgeInsets.all(Constants.DEFAULT_PADDING),
                margin: const EdgeInsets.only(top: 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Form(
                              key: _idFormkey,
                              child: CustomTextFormFeild(
                                  controller: userNotifier.idController,
                                  hintText: "아이디",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "아이디를 입력해주세요 !";
                                    }
                                    //TODO 황지민 : 중복된 확인
                                    return null;
                                  },
                                  textInputType: TextInputType.text),
                            )),
                        Container(
                          height: 50,
                          width: 90,
                          margin: const EdgeInsets.only(left: 10),
                          child: OutlinedButton(
                              onPressed: () => {
                                    if (_idFormkey.currentState!.validate())
                                      {
                                        userNotifier.isVerify = true,
                                        showAlert(context, "확인", "인증되었습니다.",
                                            () {
                                          Navigator.of(context).pop();
                                        })
                                      }
                                  },
                              child: const Text(
                                "중복 확인",
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ],
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    //TODO 황지민 20240508: 비밀번호 검증 처리 해야함
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
                        IconButton(
                          padding: const EdgeInsets.only(right: 0),
                          onPressed: () {},
                          icon: const Icon(
                            Icons.info_outline,
                            color: Colors.black87,
                            size: 25,
                          ),
                        ),
                        const Padding(
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
                          child: const Text("완료")),
                    ),
                  ],
                )))
      ],
    )));
  }
}
