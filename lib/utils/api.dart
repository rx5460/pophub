import 'package:pophub/model/popup_model.dart';
import 'package:pophub/model/review_model.dart';
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
  static Future<Map<String, dynamic>> getProfile(String userId) async {
    final data = await getData('$domain/user/$userId', {});
    Logger.debug("### 프로필 조회 $data");
    return data;
  }

  // 전체 팝업 조회
  static Future<List<PopupModel>> getPopupList() async {
    try {
      final List<dynamic> dataList = await getListData(
        '$domain/popup/popular',
        {},
      );

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
    print(storeId);
    try {
      final Map<String, dynamic> data =
          await getData('$domain/popup/view/$storeId', {});

      return PopupModel.fromJson(data);
    } catch (e) {
      // 오류 처리
      print('팝업스토어 조회 오류: $e');
      throw Exception('Failed to fetch popup');
    }
  }

  // 팝업스토어 예약
  static Future<Map<String, dynamic>> popupReservation(
      String popup, String visitorName, int count, String userId) async {
    final data = await postData('$domain/popup/reservation/$popup', {
      'user_id': userId,
      'wait_visitor_name': visitorName,
      'wait_visitor_number': count
    });
    Logger.debug("### 예약 $data");
    return data;
  }

  //리뷰 조회
  static Future<List<ReviewModel>> getReviewList(String popup) async {
    try {
      final List<dynamic> dataList =
          await getListData('$domain/popup/reviews/store/$popup', {});

      List<ReviewModel> reviewList =
          dataList.map((data) => ReviewModel.fromJson(data)).toList();
      return reviewList;
    } catch (e) {
      // 오류 처리
      print('Failed to fetch review list: $e');
      throw Exception('Failed to fetch review list');
    }
  }

  //리뷰 작성
  static Future<Map<String, dynamic>> writeReview(
      String popup, double rating, String content, String userId) async {
    final data = await postData('$domain/popup/review/create/$popup', {
      'user_id': userId,
      'review_rating': rating,
      'review_content': content
    });
    Logger.debug("### 리뷰 작성 $data");
    return data;
  }

  // 닉네임 중복 체크
  static Future<Map<String, dynamic>> nameCheck(String userName) async {
    final data = await getData('$domain/user/check/?userName=$userName', {});
    Logger.debug("### 닉네임 중복 확인 $data");
    return data;
  }

  //결제
  static Future<Map<String, dynamic>> pay(String userId, String itemName,
      int quantity, int totalAmount, int vatAmount, int taxFreeAmount) async {
    final data = await postData('$domain/pay', {
      'userId': userId,
      "itemName": itemName,
      "quantity": quantity,
      "totalAmount": totalAmount,
      "vatAmount": vatAmount,
      "taxFreeAmount": taxFreeAmount
    });
    Logger.debug("### 결제 $data");
    return data;
  }

  // 아이디 조회
  static Future<Map<String, dynamic>> getId(
      String phoneNumber, String token) async {
    final data =
        await getNoAuthData('$domain/user/search_id/:$phoneNumber', {});
    Logger.debug("### 아이디 조회 $data");
    return data;
  }
}
