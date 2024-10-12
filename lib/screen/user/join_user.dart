import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/notifier/UserNotifier.dart';
import 'package:pophub/screen/custom/custom_text_form_feild.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/user/profile_add.dart';
import 'package:pophub/utils/api/user_api.dart';
import 'package:pophub/utils/log.dart';
import 'package:pophub/utils/utils.dart';
import 'package:provider/provider.dart';

class JoinUser extends StatefulWidget {
  const JoinUser({super.key});

  @override
  State<JoinUser> createState() => _JoinUserState();
}

class _JoinUserState extends State<JoinUser> {
  String? userRole = "General Member";
  final _idFormkey = GlobalKey<FormState>();
  final _pwFormkey = GlobalKey<FormState>();
  final _confirmPwFormkey = GlobalKey<FormState>();
  bool joinComplete = false;

  late final TextEditingController idController = TextEditingController();
  late final TextEditingController pwController = TextEditingController();
  late final TextEditingController confirmPwController =
      TextEditingController();
  TextEditingController nicknameController = TextEditingController();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool checked = false;

  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    confirmPwController.dispose();
    super.dispose();
  }

  Future<void> singUpApi() async {
    final data = await UserApi.postSignUp(
        idController.text, pwController.text, userRole.toString());

    if (!mounted) return;

    if (data.toString().contains(('complete').tr())) {
      joinComplete = true;
      showAlert(context, ('check').tr(),
          ('membership_registration_has_been_completed').tr(), () {
        loginApi();
        // if (mounted) {
        //   Navigator.of(context).pop();
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => const Login()),
        //   );
        // }
      });
    } else {
      joinComplete = false;
      showAlert(
          context, ('warning').tr(), ('membership_registration_failed').tr(),
          () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
    userNotifier.refresh();
  }

  Future<void> loginApi() async {
    Map<String, dynamic> data =
        await UserApi.postLogin(idController.text, pwController.text);

    if (!data.toString().contains("fail")) {
      if (data['token'].isNotEmpty) {
        // 토큰 추가
        await _storage.write(key: 'token', value: data['token']);
        // User 싱글톤에 user_id 추가
        User().userId = data['userId'];

        Logger.debug(userRole.toString());

        if (mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider(
                                create: (_) => UserNotifier())
                          ],
                          child: ProfileAdd(
                            refreshProfile: () {},
                            useCallback: false,
                            isUser: userRole == "General Member",
                          ))));
        }
      }
    } else {
      if (mounted) {
        showAlert(context, ('warning').tr(), ('login_processing_failed').tr(),
            () {
          Navigator.of(context).pop();
        });
      }
    }
    userNotifier.refresh();
  }

  Future<void> idCheckApi() async {
    if (idController.text == "") {
      showAlert(context, ('warning').tr(), ('please_enter_your_id').tr(), () {
        Navigator.of(context).pop();
      });
    }

    Map<String, dynamic> data = await UserApi.getIdCheck(idController.text);

    if (mounted) {
      if (!data.toString().contains("Exists")) {
        showAlert(context, ('guide').tr(), ('id_can_be_used').tr(), () {
          Navigator.of(context).pop();
        });
        setState(() {
          checked = true;
        });
      } else {
        showAlert(context, ('warning').tr(), ('id_is_duplicated').tr(), () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return SafeArea(
        child: Scaffold(
            body: Center(
                child: Container(
                    padding: const EdgeInsets.only(
                        left: Constants.DEFAULT_PADDING,
                        right: Constants.DEFAULT_PADDING,
                        top: Constants.DEFAULT_PADDING,
                        bottom: Constants.DEFAULT_PADDING),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        CustomTitleBar(titleName: ('join_the_membership').tr()),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Form(
                                    key: _idFormkey,
                                    child: CustomTextFormFeild(
                                      controller: idController,
                                      hintText: ('hintText').tr(),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return ('please_enter_your_id_1')
                                              .tr();
                                        }
                                        //TODO 황지민 : 중복된 확인
                                        return null;
                                      },
                                      textInputType: TextInputType.text,
                                      onChange: () => {},
                                    ),
                                  )),
                              SizedBox(
                                width: screenWidth * 0.01,
                              ),
                              SizedBox(
                                width: screenWidth * 0.2,
                                height: screenHeight * 0.065,
                                child: OutlinedButton(
                                  onPressed: () {
                                    if (checked) {
                                      setState(() {
                                        checked = false;
                                      });
                                    } else if (idController.text != '') {
                                      idCheckApi();
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      checked
                                          ? ('correction').tr()
                                          : ('duplicate_check').tr(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          padding: const EdgeInsets.only(left: 5, right: 5),
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
                        Container(
                          margin: const EdgeInsets.only(top: 15, bottom: 15),
                          padding: const EdgeInsets.only(left: 5, right: 5),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 4),
                            ),
                            const Icon(
                              Icons.info_outline,
                              color: Colors.black87,
                              size: 25,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  ('if_you_would_like_to_register_a_popup_store_please_sign_up_as_a_seller')
                                      .tr(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio<String>(
                              value: 'General Member',
                              groupValue: userRole,
                              onChanged: (value) {
                                setState(() {
                                  userRole = value;
                                });
                              },
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: 0),
                            ),
                            Text(('user').tr()),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                            ),
                            Radio<String>(
                              value: 'President',
                              groupValue: userRole,
                              onChanged: (value) {
                                setState(() {
                                  userRole = value;
                                });
                              },
                              visualDensity: const VisualDensity(
                                  horizontal: -4, vertical: 0),
                            ),
                            Text(('seller').tr()),
                            // Radio<String>(
                            //   value: 'Manager',
                            //   groupValue: userRole,
                            //   onChanged: (value) {
                            //     setState(() {
                            //       userRole = value;
                            //     });
                            //   },
                            //   visualDensity: const VisualDensity(
                            //       horizontal: -4, vertical: 0),
                            // ),
                            // Text('맛스타'),
                          ],
                        ),
                        const Spacer(flex: 40),
                        Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          height: 48,
                          width: double.infinity,
                          child: OutlinedButton(
                              onPressed: () => {
                                    if (_idFormkey.currentState!.validate() &&
                                        _pwFormkey.currentState!.validate() &&
                                        _confirmPwFormkey.currentState!
                                            .validate())
                                      {
                                        if (checked)
                                          {
                                            singUpApi(),
                                          }
                                        else
                                          {
                                            showAlert(
                                                context,
                                                ('warning').tr(),
                                                ('please_check_for_duplicate_ids')
                                                    .tr(), () {
                                              Navigator.of(context).pop();
                                            })
                                          }
                                      }
                                  },
                              child: Text(('complete').tr())),
                        ),
                      ],
                    )))));
  }
}
