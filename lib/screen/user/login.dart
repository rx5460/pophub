import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pophub/assets/constants.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/notifier/UserNotifier.dart';
import 'package:pophub/screen/custom/custom_title_bar.dart';
import 'package:pophub/screen/nav/bottom_navigation.dart';
import 'package:pophub/screen/user/find_id.dart';
import 'package:pophub/screen/user/join_cerifi_phone.dart';
import 'package:pophub/screen/user/kakao_login.dart';
import 'package:pophub/screen/user/reset_passwd.dart';
import 'package:pophub/utils/api/user_api.dart';
import 'package:pophub/utils/utils.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loginCompelete = false;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  late final TextEditingController idController = TextEditingController();
  late final TextEditingController pwController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    super.dispose();
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

        //await Api.profileAdd();

        if (mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MultiProvider(providers: [
                        ChangeNotifierProvider(create: (_) => UserNotifier())
                      ], child: const BottomNavigationPage())));
        }
      }
    } else {
      if (mounted) {
        showAlert(context, ('warning').tr(),
            ('please_check_your_id_and_password').tr(), () {
          Navigator.of(context).pop();
        });
      }
    }
    userNotifier.refresh();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                    // width: double.infinity,
                    padding: const EdgeInsets.all(Constants.DEFAULT_PADDING),
                    child: Column(
                      children: <Widget>[
                        CustomTitleBar(
                            titleName: ('titleName_3').tr(),
                            onBackPressed: () {
                              if (context.mounted) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MultiProvider(
                                                providers: [
                                                  ChangeNotifierProvider(
                                                      create: (_) =>
                                                          UserNotifier())
                                                ],
                                                child:
                                                    const BottomNavigationPage())));
                              }
                            }),
                        Image.asset(
                          'assets/images/logo.png',
                          height: 150,
                          width: 150,
                        ),
                        TextField(
                            controller: idController,
                            decoration:
                                InputDecoration(hintText: ('hintText').tr())),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                        ),
                        TextField(
                            controller: pwController,
                            obscureText: true,
                            decoration:
                                InputDecoration(hintText: ('hintText_1').tr())),
                        Container(
                          margin: const EdgeInsets.only(top: 0, bottom: 10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MultiProvider(providers: [
                                                    ChangeNotifierProvider(
                                                        create: (_) =>
                                                            UserNotifier())
                                                  ], child: const FindId())))
                                    },
                                child: Text(('find_id').tr())),
                            TextButton(
                                onPressed: () => {
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
                                    },
                                child: Text(('reset_password').tr())),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 48,
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: OutlinedButton(
                              onPressed: () => {loginApi()},
                              child: Text(('titleName_3').tr())),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(('dont_have_an_account').tr()),
                            TextButton(
                                onPressed: () => {
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
                                                          const CertifiPhone())))
                                    },
                                child: Text(
                                  ('join_the_membership').tr(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Row(
                          children: <Widget>[
                            const Expanded(
                              child: Divider(
                                color: Constants.DEFAULT_COLOR,
                                thickness: 1,
                                endIndent: 10,
                              ),
                            ),
                            Text(
                              ('or').tr(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: Constants.DEFAULT_COLOR,
                                thickness: 1,
                                indent: 10,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Container(
                          width: double.infinity,
                          height: 48,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const KakaoLoginPage(
                                            url:
                                                'http://3.233.20.5:3000/user/oauth/naver',
                                          )));
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF03C75A),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Image.asset(
                                      'assets/images/naver_icon.png',
                                      height: 60,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      ('naver_login').tr(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 48,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const KakaoLoginPage(
                                            url:
                                                'http://3.233.20.5:3000/user/auth/kakao',
                                          )));
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: const Color(0xFFFFE812),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Image.asset(
                                      'assets/images/kakao_icon.png',
                                      height: 60,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      ('kakao_login').tr(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            )));
  }
}
