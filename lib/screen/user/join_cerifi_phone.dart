import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/notifier/UserNotifier.dart';
import 'package:pophub/screen/custom/custom_text_form_feild.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/custom/custom_toast.dart';
import 'package:pophub/screen/user/join_user.dart';
import 'package:pophub/utils/api/user_api.dart';
import 'package:pophub/utils/log.dart';
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
  bool isDialogShowing = false;

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

    if (!mounted) return;
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
        if (!mounted) return;

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
      }
    } else {
      if (!isDialogShowing) {
        setState(() {
          isDialogShowing = true;
        });
        if (!mounted) return;

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
                    CustomTitleBar(titleName: ('titleName_6').tr()),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: double.infinity,
                      child: Text(
                        ('to_prevent_theftnplease_complete_your_identity_verification')
                            .tr(),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
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
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                          onPressed: () => {
                                if (true)
                                  {
                                    User().phoneNumber = phoneController.text,
                                    phoneController.text = "",
                                    certifiController.text = "",
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const JoinUser()))
                                  }
                                else
                                  {
                                    showAlert(
                                        context,
                                        "",
                                        ('please_complete_mobile_phone_verification')
                                            .tr(), () {
                                      Navigator.of(context).pop();
                                    })
                                  }
                              },
                          child: Text(('complete').tr())),
                    ),
                  ],
                )),
          ),
        ));
      },
    );
  }
}
