import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/notifier/UserNotifier.dart';
import 'package:pophub/screen/custom/custom_text_form_feild.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/custom/custom_toast.dart';
import 'package:pophub/utils/log.dart';
import 'package:pophub/screen/user/login.dart';
import 'package:pophub/utils/api.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';

class FindId extends StatefulWidget {
  const FindId({super.key});

  @override
  State<FindId> createState() => _FindIdState();
}

class _FindIdState extends State<FindId> {
  get http => null;
  final _phoneFormkey = GlobalKey<FormState>();
  final _certifiFormkey = GlobalKey<FormState>();
  late Future<String> data;

  @override
  void dispose() {
    userNotifier.phoneController.text = "";
    userNotifier.certifiController.text = "";
    userNotifier.isVerify = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(
      builder: (_, userNotifier, child) {
        // TODO : 황지민 나중에 수정 필요
        return SafeArea(
            child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Padding(
                padding: const EdgeInsets.all(Constants.DEFAULT_PADDING),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const CustomTitleBar(titleName: "아이디 찾기"),
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
                                if (_phoneFormkey.currentState!.validate())
                                  {
                                    Api.sendCertifi(userNotifier
                                        .phoneController.text
                                        .toString()),
                                    User().phoneNumber =
                                        userNotifier.phoneController.text,
                                    ToastUtil.customToastMsg(
                                        "전송되었습니다.", context),
                                  }
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
                                    if (value.length < 6) {
                                      return "인증번호 6자리를 입력해주세요 !";
                                    }
                                    return null;
                                  },
                                  maxlength: 6,
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
                                    if (_certifiFormkey.currentState!
                                            .validate() &&
                                        userNotifier.certifiController.text
                                                .length ==
                                            6)
                                      {
                                        // if (data ==
                                        //     userNotifier.certifiController.text)
                                        //   {
                                        //     userNotifier.isVerify = true,
                                        //     userNotifier.refresh,
                                        //     showAlert(context, "확인", "인증되었습니다.",
                                        //         () {
                                        //       Navigator.of(context).pop();
                                        //       // 키보드 내리기
                                        //       FocusManager.instance.primaryFocus
                                        //           ?.unfocus();
                                        //     })
                                        //   },
                                      }
                                  },
                              child: const Text(
                                "확인",
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ],
                    ),
                    Selector<UserNotifier, bool>(
                      selector: (_, userNotifier) => userNotifier.isVerify,
                      builder: (context, isVerifyed, child) {
                        Logger.debug("인증 완료 $isVerifyed");
                        return isVerifyed
                            ? const Text("회원님의 아이디는 ~~ 입니다.")
                            : Container();
                      },
                    ),
                    const Spacer(),
                    SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 55,
                                child: OutlinedButton(
                                    onPressed: () => {
                                          {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Login()))
                                          }
                                        },
                                    style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Colors.white),
                                        backgroundColor:
                                            const Color(0xffadd8e6),
                                        foregroundColor: Colors.white,
                                        textStyle: const TextStyle(
                                            color: Colors.white),
                                        padding: const EdgeInsets.all(0),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft:
                                                    Radius.circular(10)))),
                                    child: const Text("로그인")),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 55,
                                child: OutlinedButton(
                                    onPressed: () => {
                                          {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Login()))
                                          }
                                        },
                                    style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Colors.white),
                                        backgroundColor:
                                            const Color(0xffadd8e6),
                                        foregroundColor: Colors.white,
                                        textStyle: const TextStyle(
                                            color: Colors.white),
                                        padding: const EdgeInsets.all(0),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)))),
                                    child: const Text("비밀번호 찾기")),
                              ),
                            )
                          ],
                        ))
                  ],
                )),
          ),
        ));
      },
    );
  }
}
