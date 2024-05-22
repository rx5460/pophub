import 'package:pophub/model/popup_model.dart';
import 'package:pophub/utils/log.dart';
import 'package:pophub/utils/http.dart';

class Api {
  static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";
  // SMS 전송
  static Future<Map<String, dynamic>> sendCertifi(String phone) async {
    final data =
        await postData("$domain/user/certification", {'phoneNumber': phone});
    Logger.debug("### SMS 전송 $data");
    return data;
  }

  // SMS 인증
  static Future<Map<String, dynamic>> sendVerify(
      String authCode, String expectedCode) async {
    final data = await postData('$domain/user/verify',
        {'authCode': authCode, 'expectedCode': expectedCode});
    Logger.debug("### SMS 인증 $data");

    return data;
  }

  // 회원가입
  static Future<Map<String, dynamic>> signUp(
      String userId, String userPassword, String userRole) async {
    final data = await postData('$domain/user/sign_up',
        {'userId': userId, "userPassword": userPassword, "userRole": userRole});
    Logger.debug("### 회원가입 $data");
    return data;
  }

  // 로그인
  static Future<Map<String, dynamic>> login(
      String userId, String authPassword) async {
    final data = await postData('$domain/user/sign_in',
        {'userId': userId, 'authPassword': authPassword});
    Logger.debug("### 로그인 $data");
    return data;
  }

  // 비밀번호 변경
  static changePasswd(String userId, String userPassword) async {
    final data = await postData('$domain/user/change_password',
        {'userId': userId, "authPassword": userPassword});
    Logger.debug("### 비밀번호 변경 $data");
    return data;
  }

  // 프로필 조회
  static Future<Map<String, dynamic>> getProfile(
      String userId, String token) async {
    final data = await getData('$domain/user/search_user/$userId', {}, token);
    Logger.debug("### 프로필 조회 $data");
    return data;
  }

  // 전체 팝업 조회
  static Future<List<PopupModel>> getPopupList() async {
    try {
      final List<dynamic> dataList =
          await getListData('$domain/popup/popular', {}, '');

      List<PopupModel> popupList =
          dataList.map((data) => PopupModel.fromJson(data)).toList();
      return popupList;
    } catch (e) {
      // 오류 처리
      print('Failed to fetch popup list: $e');
      throw Exception('Failed to fetch popup list');
    }
  }

  //팝업 상세 조회(팝업 단일 조회)
  static Future<PopupModel> getPopup(String storeId) async {
    try {
      final Map<String, dynamic> data =
          await getData('$domain/popup/$storeId', {}, '');

      return PopupModel.fromJson(data);
    } catch (e) {
      // 오류 처리
      print('팝업스토어 조회 오류: $e');
      throw Exception('Failed to fetch popup');
    }
  }
}
