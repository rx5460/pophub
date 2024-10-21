import 'package:pophub/model/reservation_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/model/waiting_model.dart';
import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';

class ReservationApi {
  // static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";
  static String domain = "http://3.233.20.5:3000";

// 팝업 예약
  static Future<Map<String, dynamic>> postPopupReservationWithDetails(
      String userName,
      String popup,
      String date,
      String time,
      int count) async {
    final data = await postData('$domain/reservation/advance?storeId=$popup', {
      'userName': userName,
      'reservationDate': date,
      'reservationTime': time,
      'capacity': count
    });
    print({
      'popup': popup,
      'userName': userName,
      'reservationDate': date,
      'reservationTime': time,
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
          await getListData('$domain/reservationStatus/$popup', {});
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
    final dataList =
        await getListData('$domain/reservation/advance/$storeId', {});
    Logger.debug("### 팝업 예약 상태 조회 by storeId $dataList");

    List<ReservationModel> reservationList =
        dataList.map((data) => ReservationModel.fromJson(data)).toList();
    return reservationList;
  }

  // 예약 삭제
  static Future<Map<String, dynamic>> deleteReserve(
      String reservationId) async {
    final data = await deleteData(
        '$domain/reservation/advance/delete/$reservationId', {});
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

  // 팝업 현장대기
  static Future<Map<String, dynamic>> postPopupWaiting(
      String popup, int count) async {
    final data = await postData('$domain/reservation/waiting',
        {'userName': User().userName, 'storeId': popup, 'capacity': count});

    Logger.debug("### 팝업 현장대기 $data");
    return data;
  }

  // 팝업 현장대기 조회
  static Future<List<WaitingModel>> getPopupWaiting(String storeId) async {
    final dataList = await getListData(
        '$domain/reservation/waiting/popup?storeId=$storeId', {});
    Logger.debug("### 팝업 현장대기 조회 by storeId $dataList");

    List<WaitingModel> reservationList =
        dataList.map((data) => WaitingModel.fromJson(data)).toList();
    return reservationList;
  }

  // 팝업 현장대기 입장 승인
  static Future<Map<String, dynamic>> waitingadmission(
      String reservationId) async {
    final data = await putData('$domain/reservation/waiting/admission',
        {'reservationId': reservationId});

    Logger.debug("### 팝업 현장대기 승인 $data");
    return data;
  }
}
