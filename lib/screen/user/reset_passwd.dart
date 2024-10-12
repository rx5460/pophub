import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/notifier/UserNotifier.dart';
import 'package:pophub/screen/custom/custom_text_form_feild.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/custom/custom_toast.dart';
import 'package:pophub/screen/user/login.dart';
import 'package:pophub/utils/api/user_api.dart';
import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';
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
  bool isDialogShowing = false;
  // final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String token = "";
  String userId = "";
  final _pwFormkey = GlobalKey<FormState>();
  final _confirmPwFormkey = GlobalKey<FormState>();

  late final TextEditingController phoneController = TextEditingController();
  late final TextEditingController certifiController = TextEditingController();
  late final TextEditingController pwController = TextEditingController();
  late final TextEditingController confirmPwController =
      TextEditingController();

  String realAuthCode = "";

  @override
  void dispose() {
    phoneController.dispose();
    certifiController.dispose();
    super.dispose();
  }

  Future<void> certifiApi() async {
    final data = await UserApi.postSendCertifi(phoneController.text.toString());

    if (!data.toString().contains("fail")) {
      realAuthCode = data["Number"];
      if (mounted) {
        ToastUtil.customToastMsg(('sent').tr(), context);
      }
      setState(() {});
    } else {
      if (mounted) {
        ToastUtil.customToastMsg(('transmission_failed').tr(), context);
      }
    }
  }

  Future<void> verifyApi(String certifi, UserNotifier userNoti) async {
    final data = await UserApi.postSendVerify(certifi, realAuthCode);
    //= {"data": "Successful"};

    if (!data.toString().contains("fail")) {
      if (!isDialogShowing) {
        setState(() {
          isDialogShowing = true;
        });

        if (mounted) {
          showAlert(context, ('check').tr(), ('certified').tr(), () {
            Navigator.of(context).pop();
            FocusManager.instance.primaryFocus?.unfocus();
            userNoti.isVerify = true;
            setState(() {
              isDialogShowing = true;
            });
            userNoti.refresh();
          });
        }
      }
    } else {
      if (!isDialogShowing) {
        setState(() {
          isDialogShowing = true;
        });
        if (mounted) {
          showAlert(context, ('warning').tr(),
              ('please_check_the_authentication_number_again').tr(), () {
            Navigator.of(context).pop();
            FocusManager.instance.primaryFocus?.unfocus();

            setState(() {
              isDialogShowing = false;
            });
          });
        }
      }
    }
    Logger.debug("${userNoti.isVerify} userNotifier.isVerify");
  }

  Future<void> resetPasswdApi() async {
    final data = await UserApi.getId(phoneController.text.toString());
    Logger.debug("### userId = $userId");
    if (!data.toString().contains("fail")) {
      userId = data["userId"];
      final passwdData = await UserApi.postChangePassword(
          userId, pwController.text.toString());
      if (!passwdData.toString().contains("fail")) {
        await secureStorage.deleteAll();
        User().clear();
        if (mounted) {
          showAlert(context, ('check').tr(),
              ('password_reset_has_been_completed').tr(), () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Login()));
          });
        }
      }
    } else {
      if (mounted) {
        showAlert(context, ('check').tr(), ('password_reset_failed').tr(), () {
          Navigator.of(context).pop();
          setState(() {});
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    // double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Consumer<UserNotifier>(
      builder: (_, userNotifier, child) {
        return SafeArea(
            child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: SizedBox(
              child: Padding(
                  padding: const EdgeInsets.all(Constants.DEFAULT_PADDING),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CustomTitleBar(titleName: ('reset_password').tr()),
                      Form(
                          key: _phoneFormkey,
                          child: CustomTextFormFeild(
                            controller: phoneController,
                            hintText: ('hintText_2').tr(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ('please_enter_your_number').tr();
                              } else if (!isValidPhoneNumber(value)) {
                                return ('please_enter_your_phone_number_in_the_correct_format')
                                    .tr();
                              }
                              return null;
                            },
                            textInputType: TextInputType.number,
                            onChange: () => {},
                          )),
                      Container(
                        width: double.infinity,
                        height: 48,
                        margin: const EdgeInsets.only(top: 15),
                        child: OutlinedButton(
                            onPressed: () => {
                                  if (_phoneFormkey.currentState!.validate())
                                    {certifiApi()}
                                },
                            child: Text(('forwarding').tr())),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Form(
                                  key: _certifiFormkey,
                                  child: CustomTextFormFeild(
                                    controller: certifiController,
                                    hintText: ('hintText_3').tr(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return ('please_enter_your_authentication_number')
                                            .tr();
                                      }
                                      if (value.length < 6) {
                                        return ('please_enter_your_6digit_authentication_number')
                                            .tr();
                                      }
                                      return null;
                                    },
                                    maxlength: 6,
                                    textInputType: TextInputType.number,
                                    onChange: () => {},
                                  ))),
                          Container(
                            width: 80,
                            height: 48,
                            margin: const EdgeInsets.only(
                                top: 18, bottom: 18, left: 10),
                            child: OutlinedButton(
                                onPressed: () => {
                                      if (_certifiFormkey.currentState!
                                              .validate() &&
                                          certifiController.text.length == 6)
                                        {
                                          verifyApi(
                                              certifiController.text.toString(),
                                              userNotifier),
                                        }
                                    },
                                child: Text(
                                  ('check').tr(),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Visibility(
                        visible: isDialogShowing && userNotifier.isVerify,
                        child: Form(
                          key: _pwFormkey,
                          child: CustomTextFormFeild(
                            controller: pwController,
                            hintText: ('hintText_1').tr(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ('please_enter_your_password').tr();
                              }
                              if (value.length < 8) {
                                return ('please_enter_a_password_of_at_least_8_characters')
                                    .tr();
                              }
                              //TODO 황지민 : 중복된 확인
                              return null;
                            },
                            textInputType: TextInputType.text,
                            onChange: () => {},
                            isPw: true,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Visibility(
                        visible: isDialogShowing,
                        child: Form(
                          key: _confirmPwFormkey,
                          child: CustomTextFormFeild(
                            controller: confirmPwController,
                            hintText: ('hintText_4').tr(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ('please_enter_your_password').tr();
                              }
                              if (value.length < 8) {
                                return ('please_enter_a_password_of_at_least_8_characters')
                                    .tr();
                              }
                              if (confirmPwController.text !=
                                  pwController.text) {
                                return ('password_does_not_match').tr();
                              }
                              return null;
                            },
                            textInputType: TextInputType.text,
                            onChange: () => {},
                            isPw: true,
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: OutlinedButton(
                                      onPressed: () => {
                                            {
                                              if (_pwFormkey.currentState!
                                                      .validate() &&
                                                  _confirmPwFormkey
                                                      .currentState!
                                                      .validate())
                                                {
                                                  resetPasswdApi(),
                                                }
                                            }
                                          },
                                      style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.white),
                                          backgroundColor:
                                              Constants.DEFAULT_COLOR,
                                          foregroundColor: Colors.white,
                                          textStyle: const TextStyle(
                                              color: Colors.white),
                                          padding: const EdgeInsets.all(0),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)))),
                                      child: Text(('complete').tr())),
                                ),
                              ),
                            ],
                          ))
                    ],
                  )),
            ),
          ),
        ));
      },
    );
  }
}
