import 'package:pophub/screen/user/log.dart';
import 'package:pophub/utils/http.dart';

class Api {
  static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";
  // SMS 전송
  static sendCertifi(String phone) async {
    final data =
        await postData("$domain/user/certification", {'phoneNumber': phone});
    Logger.debug("### SMS 전송 ${data}");
    return data;
  }

  // SMS 인증
  static Future<String> sendVerify(String authCode) async {
    final data = await postData('$domain/user/verify', {
      'authCode': authCode,
    });
    Logger.debug("### SMS 인증 ${data}");

    return data.toString();
  }

  // 회원가입
  static Future<Map<String, String>> signUp(
      String userId, String userPassword, String userRole) async {
    final data = await postData('$domain/user/sign_up',
        {'userId': userId, "userPassword": userPassword, "userRole": userRole});
    Logger.debug("### 회원가입 ${data}");
    return data;
  }

  // 로그인
  static login(String userId, String userPassword, String authPassword) async {
    final data = await postData('$domain/user/sign_in',
        {'userId': userId, "authPassword": authPassword});
    Logger.debug("### 로그인 ${data}");
    return data;
  }

  // 비밀번호 변경
  static changePasswd(String userId, String userPassword) async {
    final data = await postData('$domain/user/change_password',
        {'userId': userId, "authPassword": userPassword});
    Logger.debug("### 비밀번호 변경 ${data}");
    return data;
  }
}
