import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/notifier/UserNotifier.dart';
import 'package:pophub/screen/custom/custom_text_form_feild.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/custom/custom_toast.dart';
import 'package:pophub/screen/user/login.dart';
import 'package:pophub/screen/user/reset_passwd.dart';
import 'package:pophub/utils/api/user_api.dart';
import 'package:pophub/utils/log.dart';
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
  bool isDialogShowing = false;
  String userId = "";
  bool findSuccess = false;

  late final TextEditingController phoneController = TextEditingController();
  late final TextEditingController certifiController = TextEditingController();

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

    if (data.toString().contains("Successful")) {
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
              isDialogShowing = false;
            });
            userNoti.refresh();
          });
        }

        await findIdApi();
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

  Future<void> findIdApi() async {
    final data = await UserApi.getId(phoneController.text.toString());
    Logger.debug("### userId = $userId");
    if (!data.toString().contains("fail")) {
      setState(() {
        userId = data["userId"];
        findSuccess = true;
      });
    } else {
      setState(() {
        findSuccess = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
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
                    CustomTitleBar(titleName: ('find_id').tr()),
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
                    Visibility(
                      visible: findSuccess,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(('your_id_is').tr()),
                          Text(
                            userId,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Text(('no_see').tr()),
                        ],
                      ),
                    ),
                    Visibility(
                        child: Visibility(
                            visible:
                                findSuccess == false && userNotifier.isVerify,
                            child: Center(
                              child: const Text(
                                      "there_is_no_id_corresponding_to_the__number")
                                  .tr(args: [phoneController.text.toString()]),
                            ))),
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
                                            Constants.DEFAULT_COLOR,
                                        foregroundColor: Colors.white,
                                        textStyle: const TextStyle(
                                            color: Colors.white),
                                        padding: const EdgeInsets.all(0),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)))),
                                    child: Text(('titleName_3').tr())),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: OutlinedButton(
                                    onPressed: () => {
                                          {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MultiProvider(
                                                            providers: [
                                                              ChangeNotifierProvider(
                                                                  create: (_) =>
                                                                      UserNotifier())
                                                            ],
                                                            child:
                                                                const ResetPasswd())))
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
                                    child: Text(('reset_password').tr())),
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
