import 'package:pophub/model/category_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/model/visit_model.dart';
import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';

class VisitApi {
  // static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";
  static String domain = "http://3.233.20.5:3000";

  // 사전예약 방문 인증
  static Future<Map<String, dynamic>> reservationVisit(
      String qr, String type) async {
    final data = await postData('$domain/qrcode/scan/visit?type=$type', {
      'userName': User().userName,
      'storeId': qr,
    });

    Logger.debug("### 방문 인증 $data");
    return data;
  }

  // 캘린더 조회
  static Future<List<VisitModel>> getCalendar() async {
    try {
      final List<dynamic> dataList = await getListData(
          '$domain/qrcode/calendar/show?userName=${User().userName}', {});
      List<VisitModel> calendarList =
          dataList.map((data) => VisitModel.fromJson(data)).toList();
      return calendarList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch calendar list: $e');
      throw Exception('Failed to fetch calendar list');
    }
  }
}
