import 'package:pophub/model/achieve_model.dart';
import 'package:pophub/model/point_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';

class UserApi {
  // static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";
  static String domain = "http://3.233.20.5:3000";

  // SMS 전송
  static Future<Map<String, dynamic>> postSendCertifi(String phone) async {
    final data =
        await postData("$domain/user/certification", {'phoneNumber': phone});
    Logger.debug("### SMS 전송 $data");
    return data;
  }

  // SMS 인증
  static Future<Map<String, dynamic>> postSendVerify(
      String authCode, String expectedCode) async {
    final data = await postData('$domain/user/verify',
        {'authCode': authCode, 'expectedCode': expectedCode});
    Logger.debug("### SMS 인증 $data");
    return data;
  }

  // 회원가입
  static Future<Map<String, dynamic>> postSignUp(
      String userId, String userPassword, String userRole) async {
    final data = await postData('$domain/user/signUp',
        {'userId': userId, "userPassword": userPassword, "userRole": userRole});
    Logger.debug("### 회원가입 $data");
    return data;
  }

  // 로그인
  static Future<Map<String, dynamic>> postLogin(
      String userId, String authPassword) async {
    final data = await postData('$domain/user/signIn',
        {'userId': userId, 'authPassword': authPassword});

    print(data);
    Logger.debug("### 로그인 $data");
    return data;
  }

  // 비밀번호 변경
  static postChangePassword(String userId, String userPassword) async {
    final data = await postNoAuthData('$domain/user/changePassword',
        {'userId': userId, "userPassword": userPassword});
    Logger.debug("### 비밀번호 변경 $data");
    return data;
  }

  // 프로필 조회
  static Future<Map<String, dynamic>> getProfile(String userId) async {
    final data = await getData('$domain/user/$userId', {});
    Logger.debug("### 프로필 조회 $data");
    return data;
  }

// 업적 조회
  static Future<List<Achievement>> getAchiveList() async {
    try {
      final List<dynamic> dataList = await getListData(
          '$domain/user/achieveHub/?userName=${User().userName}', {});
      List<Achievement> achieveList =
          dataList.map((data) => Achievement.fromJson(data)).toList();
      return achieveList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch achive list: $e');
      throw Exception('Failed to fetch achive list');
    }
  }

  // 닉네임 중복 체크
  static Future<Map<String, dynamic>> getNameCheck(String userName) async {
    final data = await getData('$domain/user/check/?userName=$userName', {});
    Logger.debug("### 닉네임 중복 확인 $data");
    return data;
  }

  // 프로필 수정 (이미지 x)
  static Future<Map<String, dynamic>> postProfileModify(
      String userId, String userName) async {
    final data = await postData('$domain/user/profile/update',
        {'userId': userId, 'userName': userName});
    Logger.debug("### 프로필 수정 이미지x $data");
    return data;
  }

  // 프로필 수정 (이미지 o)
  static Future<Map<String, dynamic>> postProfileModifyImage(
      String userId, String userName, image) async {
    final data = await postDataWithImage('$domain/user/profile/update',
        {'userId': userId, 'userName': userName}, 'userImage', image);
    Logger.debug("### 프로필 수정 이미지o $data");
    return data;
  }

// 아이디 조회
  static Future<Map<String, dynamic>> getId(String phoneNumber) async {
    final data = await getNoAuthData('$domain/user/searchId/$phoneNumber', {});
    Logger.debug("### 아이디 조회 $data");
    return data;
  }

  // 프로필 추가 (이미지 o)
  static Future<Map<String, dynamic>> postProfileAddWithImage(
      String nickName, String gender, String age, image, String phone) async {
    final data = await postDataWithImage(
        '$domain/user/profile/create',
        {
          'userId': User().userId,
          'userName': nickName,
          'phoneNumber': phone,
          'Gender': gender,
          'Age': age,
        },
        'file',
        image);
    Logger.debug("### 프로필 추가 이미지o $data");
    return data;
  }

  // 프로필 추가 (이미지 x)
  static Future<Map<String, dynamic>> postProfileAdd(
      String nickName, String gender, String age, String phone) async {
    final data = await postData('$domain/user/profile/create', {
      'userId': User().userId,
      'userName': nickName,
      'phoneNumber': phone,
      'Gender': gender,
      'Age': age,
    });
    Logger.debug("### 프로필 추가 이미지x $data");
    return data;
  }

// 회원탈퇴
  static Future<Map<String, dynamic>> postUserDelete() async {
    final data = await postData('$domain/user/delete/',
        {'userId': 'jimin01', 'phoneNumber': User().phoneNumber});
    Logger.debug("### 회원탈퇴 $data");
    return data;
  }

  // 아이디 중복 체크
  static Future<Map<String, dynamic>> getIdCheck(String userId) async {
    final data = await getData('$domain/user/check/?userId=$userId', {});
    Logger.debug("### 아이디 중복 확인 $data");
    return data;
  }

  // 카카오 api 조회
  static Future<Map<String, dynamic>> getAddress(String location) async {
    String encode = Uri.encodeComponent(location);
    final data = await getKaKaoApi(
        'https://dapi.kakao.com/v2/local/search/address.json?nalyze_type=similar&page=1&size=10&query=$encode',
        {});
    return data;
  }

  // 전체 포인트 조회
  static Future<List<PointModel>> getPointList() async {
    final dataList =
        await getListData('$domain/user/point?userName=${User().userName}', {});
    List<PointModel> pointList =
        dataList.map((data) => PointModel.fromJson(data)).toList();
    Logger.debug("### 포인트 조회 $pointList");
    return pointList;
  }
}
