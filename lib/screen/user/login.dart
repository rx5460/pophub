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
        User().userId = data['user_id'];

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
        showAlert(context, "경고", "아이디와 비밀번호를 확인해주세요.", () {
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
                            titleName: "로그인",
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
                            decoration: const InputDecoration(hintText: "아이디")),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                        ),
                        TextField(
                            controller: pwController,
                            obscureText: true,
                            decoration:
                                const InputDecoration(hintText: "비밀번호")),
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
                                child: const Text("아이디 찾기")),
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
                                child: const Text("비밀번호 재설정")),
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
                              child: const Text("로그인")),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text("계정이 없으신가요?"),
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
                                child: const Text(
                                  "회원가입",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.01),

                        const Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: Constants.DEFAULT_COLOR,
                                thickness: 1,
                                endIndent: 10,
                              ),
                            ),
                            Text(
                              '또는',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            Expanded(
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
                                                'http://3.88.120.90:3000/user/oauth/naver',
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
                                  const Expanded(
                                    child: Text(
                                      "네이버 로그인",
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
                                                'http://3.88.120.90:3000/user/oauth/kakao',
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
                                  const Expanded(
                                    child: Text(
                                      "카카오 로그인",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Google login button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () {
                              // Handle Google login
                            },
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: Colors.grey)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Image.asset(
                                      'assets/images/google_icon.png',
                                      height: 60,
                                    ),
                                  ),
                                  const Expanded(
                                    child: Text(
                                      "Google 계정으로 로그인",
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
