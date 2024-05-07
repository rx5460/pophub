import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/notifier/UserNotifier.dart';
import 'package:pophub/screen/custom/custom_text_form_feild.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/user/join_user.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';

class VerifyPhone extends StatefulWidget {
  const VerifyPhone({super.key});

  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  get http => null;
  final _phoneFormkey = GlobalKey<FormState>();
  final _verifyFormkey = GlobalKey<FormState>();

  void fetchData() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

    if (response.statusCode == 200) {
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(
      builder: (_, userNotifier, child) {
        return SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Stack(
                  children: [
                    const CustomTitleBar(titleName: "휴대폰 본인 인증"),
                    Center(
                      child: Padding(
                          padding:
                              const EdgeInsets.all(Constants.DEFAULT_PADDING),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.only(top: 70, bottom: 20),
                                child: const Text(
                                  "도용 방지를 위해\n본인 인증을 완료해주세요!",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Form(
                                  key: _phoneFormkey,
                                  child: CustomTextFormFeild(
                                      controller: userNotifier.phoneController,
                                      hintText: "핸드폰 번호 입력",
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "번호를 입력해주세요 !";
                                        } else if (!isValidPhoneNumber(value)) {
                                          return "전화번호 형식에 맞게 입력해주세요 !";
                                        }
                                        return null;
                                      },
                                      textInputType: TextInputType.number)),
                              Container(
                                width: double.infinity,
                                height: 50,
                                margin: const EdgeInsets.only(top: 30),
                                child: OutlinedButton(
                                    onPressed: () => {
                                          if (_phoneFormkey.currentState!
                                              .validate())
                                            {
                                              //TODO 황지민 : 인증번호 전송하기
                                              User().phoneNumber = userNotifier
                                                  .phoneController.text,
                                              debugPrint(
                                                  "${User().phoneNumber} 폰번호"),
                                            }

                                          //todo
                                        },
                                    child: const Text("전송")),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Form(
                                          key: _verifyFormkey,
                                          child: CustomTextFormFeild(
                                              controller:
                                                  userNotifier.verifyController,
                                              hintText: "인증번호 입력",
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "인증번호를 입력해주세요!";
                                                }
                                                return null;
                                              },
                                              maxlength: 5,
                                              textInputType:
                                                  TextInputType.number))),
                                  Container(
                                    width: 80,
                                    height: 50,
                                    margin: const EdgeInsets.only(
                                        top: 30, bottom: 30, left: 10),
                                    child: OutlinedButton(
                                        onPressed: () => {
                                              //TODO 황지민 : 인증번호 체크하기
                                              if (_verifyFormkey.currentState!
                                                  .validate())
                                                {
                                                  userNotifier.isVerify = true,
                                                  showAlert(
                                                      context, "확인", "인증되었습니다.",
                                                      () {
                                                    Navigator.of(context).pop();
                                                  })
                                                }
                                            },
                                        child: const Text(
                                          "확인",
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: OutlinedButton(
                                    onPressed: () => {
                                          if (userNotifier.isVerify)
                                            {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const JoinUser()))
                                            }
                                          else
                                            {
                                              showAlert(context, "경고",
                                                  "핸드폰 인증을 완료해주세요.", () {
                                                Navigator.of(context).pop();
                                              })
                                            }
                                        },
                                    child: const Text("완료")),
                              ),
                            ],
                          )),
                    ),
                  ],
                )));
      },
    );
  }
}
