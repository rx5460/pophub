import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/notifier/UserNotifier.dart';
import 'package:pophub/screen/custom/custom_text_form_feild.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/custom/custom_toast.dart';
import 'package:pophub/screen/user/join_user.dart';
import 'package:pophub/utils/api.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';

class CertifiPhone extends StatefulWidget {
  const CertifiPhone({super.key});

  @override
  State<CertifiPhone> createState() => _CertifiPhoneState();
}

class _CertifiPhoneState extends State<CertifiPhone> {
  get http => null;
  final _phoneFormkey = GlobalKey<FormState>();
  final _certifiFormkey = GlobalKey<FormState>();

  @override
  void dispose() {
    // userNotifier.phoneController.text = "";
    // userNotifier.certifiController.text = "";
    super.dispose();
  }

  Future<void> verifyApi() async {
    final data = Api.sendVerify(
      userNotifier.certifiController.text.toString(),
    );

    if (data.toString().contains("성공")) {
      userNotifier.isVerify = true;
    } else {
      userNotifier.isVerify = false;
    }
    userNotifier.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(
      builder: (_, userNotifier, child) {
        return SafeArea(
            child: Scaffold(
          body: Center(
            child: Padding(
                padding: const EdgeInsets.all(Constants.DEFAULT_PADDING),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const CustomTitleBar(titleName: "휴대폰 본인 인증"),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: double.infinity,
                      child: const Text(
                        "도용 방지를 위해\n본인 인증을 완료해주세요!",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                      margin: const EdgeInsets.only(top: 15),
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
                              top: 18, bottom: 18, left: 10),
                          child: OutlinedButton(
                              onPressed: () => {
                                    if (_certifiFormkey.currentState!
                                            .validate() &&
                                        userNotifier.certifiController.text
                                                .length ==
                                            6)
                                      {
                                        verifyApi(),
                                        if (userNotifier.isVerify)
                                          {
                                            showAlert(context, "확인", "인증되었습니다.",
                                                () {
                                              Navigator.of(context).pop();

                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            })
                                          },
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
                      height: 55,
                      child: OutlinedButton(
                          onPressed: () => {
                                ///TODO 황지민 : 테스트 코드
                                if (true)
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const JoinUser()))
                                  }
                                else
                                  {
                                    showAlert(context, "경고", "핸드폰 인증을 완료해주세요.",
                                        () {
                                      Navigator.of(context).pop();
                                    })
                                  }
                              },
                          child: const Text("완료")),
                    ),
                  ],
                )),
          ),
        ));
      },
    );
  }
}
