import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/notifier/UserNotifier.dart';
import 'package:pophub/screen/custom/custom_text_form_feild.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/custom/custom_toast.dart';
import 'package:pophub/screen/user/login.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';

class ResetPasswd extends StatefulWidget {
  const ResetPasswd({super.key});

  @override
  State<ResetPasswd> createState() => _ResetPasswdState();
}

class _ResetPasswdState extends State<ResetPasswd> {
  get http => null;
  final _phoneFormkey = GlobalKey<FormState>();
  final _certifiFormkey = GlobalKey<FormState>();
  final _idFormkey = GlobalKey<FormState>();
  final _pwFormkey = GlobalKey<FormState>();
  final _confirmPwFormkey = GlobalKey<FormState>();

  @override
  void dispose() {
    userNotifier.phoneController.text = "";
    userNotifier.certifiController.text = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(
      builder: (_, userNotifier, child) {
        return SafeArea(
            child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Padding(
                padding: const EdgeInsets.all(Constants.DEFAULT_PADDING),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const CustomTitleBar(titleName: "비밀번호 재설정"),
                    Form(
                      key: _idFormkey,
                      child: CustomTextFormFeild(
                        controller: userNotifier.idController,
                        hintText: "아이디",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "아이디를 입력해주세요 !";
                          }
                          return null;
                        },
                        textInputType: TextInputType.text,
                        onChange: () => {},
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
                          textInputType: TextInputType.number,
                          onChange: () => {},
                        )),
                    Container(
                      width: double.infinity,
                      height: 55,
                      margin: const EdgeInsets.only(top: 30),
                      child: OutlinedButton(
                          onPressed: () => {
                                if (_idFormkey.currentState!.validate() &&
                                    _phoneFormkey.currentState!.validate())
                                  {
                                    //fetchData(),
                                    //TODO 황지민 : 인증번호 전송하기
                                    User().phoneNumber =
                                        userNotifier.phoneController.text,
                                    ToastUtil.customToastMsg(
                                        "전송되었습니다.", context),
                                  }

                                //todo
                              },
                          child: const Text("전송")),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Form(
                                key: _certifiFormkey,
                                child: CustomTextFormFeild(
                                  controller: userNotifier.certifiController,
                                  hintText: "인증번호 입력",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "인증번호를 입력해주세요!";
                                    }
                                    if (value.length < 5) {
                                      return "인증번호 5자리를 입력해주세요 !";
                                    }
                                    return null;
                                  },
                                  maxlength: 5,
                                  textInputType: TextInputType.number,
                                  onChange: () => {},
                                ))),
                        Container(
                          width: 80,
                          height: 55,
                          margin: const EdgeInsets.only(
                              top: 30, bottom: 30, left: 10),
                          child: OutlinedButton(
                              onPressed: () => {
                                    //TODO 황지민 : 인증번호 체크하기
                                    if (_certifiFormkey.currentState!
                                            .validate() &&
                                        userNotifier.certifiController.text
                                                .length ==
                                            5)
                                      {
                                        userNotifier.isVerify = true,
                                        showAlert(context, "확인", "인증되었습니다.",
                                            () {
                                          Navigator.of(context).pop();
                                          // 키보드 내리기
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
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
                    Form(
                      key: _pwFormkey,
                      child: CustomTextFormFeild(
                        controller: userNotifier.pwController,
                        hintText: "비밀번호",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "비밀번호를 입력해주세요 !";
                          }
                          if (value.length < 8) {
                            return '비밀번호는 8자 이상으로 입력해주세요.';
                          }
                          //TODO 황지민 : 중복된 확인
                          return null;
                        },
                        textInputType: TextInputType.text,
                        onChange: () => {},
                        isPw: true,
                      ),
                    ),
                    Form(
                      key: _confirmPwFormkey,
                      child: CustomTextFormFeild(
                        controller: userNotifier.confirmPwController,
                        hintText: "비밀번호 재입력",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "비밀번호를 입력해주세요 !";
                          }
                          if (value.length < 8) {
                            return '비밀번호는 8자 이상으로 입력해주세요.';
                          }
                          if (value != userNotifier.pwController.text) {
                            return '비밀번호가 일치하지 않습니다.';
                          }
                          //TODO 황지민 : 중복된 확인
                          return null;
                        },
                        textInputType: TextInputType.text,
                        onChange: () => {},
                        isPw: true,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton(
                          onPressed: () => {
                                if ( //TODO 황지민 : 인증번호 체크 로직 추가
                                    _pwFormkey.currentState!.validate() &&
                                        _confirmPwFormkey.currentState!
                                            .validate())
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Login()))
                                  },
                              },
                          child: const Text("완료")),
                    )
                  ],
                )),
          ),
        ));
      },
    );
  }
}
