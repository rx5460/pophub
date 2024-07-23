import 'package:pophub/model/reservation_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';

class ReservationwApi {
  static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";

// 팝업 예약
  static Future<Map<String, dynamic>> postPopupReservationWithDetails(
      String userName,
      String popup,
      String date,
      String time,
      int count) async {
    final data = await postData('$domain/popup/reservation/$popup/', {
      'user_name': userName,
      'reservation_date': date,
      'reservation_time': time,
      'capacity': count
    });
    print({
      'user_name': userName,
      'reservation_date': date,
      'reservation_time': time,
      'capacity': count
    });
    Logger.debug("### 팝업 예약 $data");
    return data;
  }

  // 팝업 예약 상태 조회
  static Future<List<ReservationModel>> getReservationStatus(
      String popup) async {
    try {
      final dataList =
          await getListData('$domain/popup/reservationStatus/$popup', {});
      Logger.debug("### 예약 상태 조회 $dataList");

      List<ReservationModel> reservationList =
          dataList.map((data) => ReservationModel.fromJson(data)).toList();
      return reservationList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch reservation list: $e');
      throw Exception('Failed to fetch reservation list');
    }
  }

// 팝업 예약 상태 조회 by store
  static Future<List<ReservationModel>> getReservationByStoreId(
      String storeId) async {
    final dataList = await getListData(
        '$domain/popup/getReservation/president/$storeId', {});
    Logger.debug("### 팝업 예약 상태 조회 by storeId $dataList");

    List<ReservationModel> reservationList =
        dataList.map((data) => ReservationModel.fromJson(data)).toList();
    return reservationList;
  }

  // 예약 삭제
  static Future<Map<String, dynamic>> deleteReserve(
      String reservationId) async {
    final data =
        await deleteData('$domain/popup/deleteReservation/$reservationId', {});
    Logger.debug("### 예약 삭제 $data");
    return data;
  }

  // 팝업 예약 상태 조회 by name
  static Future<List<ReservationModel>> getReservationByUserName() async {
    final dataList = await getListData(
        '$domain/popup/getReservation/user/${User().userName}', {});
    Logger.debug("### 팝업 예약 상태 조회 by name $dataList");

    List<ReservationModel> reservationList =
        dataList.map((data) => ReservationModel.fromJson(data)).toList();
    return reservationList;
  }
}
