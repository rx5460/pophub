import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pophub/model/popup_model.dart';
import 'package:pophub/model/schedule_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/notifier/StoreNotifier.dart';
import 'package:pophub/utils/api/user_api.dart';
import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';
import 'package:pophub/utils/utils.dart';

class StoreApi {
  // static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";
  static String domain = "http://3.88.120.90:3000";

// 인기 팝업 조회
  static Future<List<PopupModel>> getPopupList() async {
    try {
      final List<dynamic> dataList =
          await getListData('$domain/popup/popular', {});
      List<PopupModel> popupList =
          dataList.map((data) => PopupModel.fromJson(data)).toList();
      return popupList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch popup list: $e');
      throw Exception('Failed to fetch popup list');
    }
  }

  // 팝업스토어 조회
  static Future<PopupModel> getPopup(
      String storeId, bool getLocation, String userName) async {
    Logger.debug(storeId);
    try {
      Map<String, dynamic> data =
          // await getData('$domain/popup/view/$storeId/$userName', {});
          await getData('$domain/popup/view/$storeId?userName=$userName', {});
      print('$domain/popup/view/$storeId/$userName');
      print('팝업 데이터 : $data');
      if (getLocation) {
        PopupModel popupModel = PopupModel.fromJson(data);
        final locationData = await UserApi.getAddress(
            popupModel.location.toString().split("/")[0] != ""
                ? popupModel.location.toString().split("/")[0]
                : "서울특별시 강남구 강남대로 지하396");

        var documents = locationData['documents'];
        if (documents != null && documents.isNotEmpty) {
          var firstDocument = documents[0];
          var x = firstDocument['x'];
          var y = firstDocument['y'];
          data['x'] = x;
          data['y'] = y;
        } else {
          Logger.debug('No documents found');
        }
      }

      return PopupModel.fromJson(data);
    } catch (e) {
      // 오류 처리
      Logger.debug('팝업스토어 조회 오류: $e');
      throw Exception('Failed to fetch popup');
    }
  }

  // 팝업스토어 예약
  static Future<Map<String, dynamic>> postPopupReservation(
      String popup, String visitorName, int count, String userId) async {
    final data = await postData('$domain/popup/reservation/$popup', {
      'userId': userId,
      'waitVisitorName': visitorName,
      'waitVisitorNumber': count
    });
    Logger.debug("### 예약 $data");
    return data;
  }

  // 팝업 좋아요
  static Future<Map<String, dynamic>> postStoreLike(
      String userName, String popup) async {
    final data =
        await postData('$domain/popup/like/$popup/', {'userName': userName});
    Logger.debug(popup);
    Logger.debug("### 팝업 좋아요 $data");
    return data;
  }

// 스토어 추가
  static Future<Map<String, dynamic>> postStoreAdd(StoreModel store) async {
    FormData formData = FormData();

    // 파일 추가
    for (var imageMap in store.images) {
      if (imageMap['type'] == 'file') {
        var file = imageMap['data'] as File;
        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last),
        ));
      }
    }

    formData.fields.addAll([
      MapEntry('categoryId', store.category),
      MapEntry('userName', User().userName),
      MapEntry('storeName', store.name),
      MapEntry('storeLocation', "${store.location}/${store.locationDetail}"),
      MapEntry('storeContactInfo', store.contact),
      MapEntry('storeDescription', store.description),
      MapEntry(
          'storeStartDate', store.startDate.toIso8601String().split('T').first),
      MapEntry(
          'storeEndDate', store.endDate.toIso8601String().split('T').first),
      MapEntry('maxCapacity', store.maxCapacity.toString()),
    ]);

    if (store.schedule != null) {
      for (int i = 0; i < store.schedule!.length; i++) {
        Schedule schedule = store.schedule![i];

        formData.fields.addAll([
          MapEntry('schedule[$i][day_of_week]',
              getDayOfWeekAbbreviation(schedule.dayOfWeek, "en"))
        ]);
        formData.fields.addAll([
          MapEntry('schedule[$i][open_time]', formatTime(schedule.openTime))
        ]);
        formData.fields.addAll([
          MapEntry('schedule[$i][close_time]', formatTime(schedule.closeTime))
        ]);
      }
    }

    final data = await postFormData('$domain/popup', formData);
    Logger.debug("### 스토어 추가 $data");
    return data;
  }

  // 펜딩 리스트
  static Future<List<PopupModel>> getPendingList() async {
    try {
      final List<dynamic> dataList =
          await getListData('$domain/admin/popupPendingList', {});
      Logger.debug("### 펜딩리스트  ${dataList.toString()}");

      List<PopupModel> popupList =
          dataList.map((data) => PopupModel.fromJson(data)).toList();
      return popupList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch review list: $e');
      throw Exception('Failed to fetch review list');
    }
  }

  // 팝업 승인
  static Future<Map<String, dynamic>> putPopupAllow(String storeId) async {
    final data =
        await putData('$domain/admin/popupPendingCheck/', {'storeId': storeId});
    Logger.debug("### 팝업 승인 $data");
    return data;
  }

  // 내 팝업스토어 조회
  static Future<List<dynamic>> getMyPopup(String userName) async {
    final data = await getListData('$domain/popup/president/$userName', {});
    Logger.debug("### 내 팝업스토어 조회 $data");
    return data;
  }

// 스토어 수정
  static Future<Map<String, dynamic>> putStoreModify(StoreModel store) async {
    FormData formData = FormData();

    // 파일 추가
    for (var imageMap in store.images) {
      if (imageMap['type'] == 'file') {
        var file = imageMap['data'] as File;
        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last),
        ));
      } else if (imageMap['type'] == 'url') {
        var url = imageMap['data'] as String;
        var response = await Dio().get<List<int>>(url,
            options: Options(responseType: ResponseType.bytes));
        formData.files.add(MapEntry(
          'files',
          MultipartFile.fromBytes(response.data!,
              filename: url.split('/').last),
        ));
      }
    }

    String locationPart = "";
    if (store.location.isNotEmpty) {
      List<String> parts = store.location.split("/");
      if (parts.length > 1) {
        locationPart = parts[1];
      }
    }
    formData.fields.addAll([
      MapEntry('categoryId', store.category),
      MapEntry('userName', User().userName),
      MapEntry('storeName', store.name),
      MapEntry(
          'storeLocation',
          locationPart == ""
              ? store.locationDetail != ""
                  ? "${store.location}/${store.locationDetail}"
                  : store.location
              : "${store.location.split("/").first}/${store.locationDetail}"),
      MapEntry('storeContactInfo', store.contact),
      MapEntry('storeDescription', store.description),
      MapEntry(
          'storeStartDate', store.startDate.toIso8601String().split('T').first),
      MapEntry(
          'storeEndDate', store.endDate.toIso8601String().split('T').first),
      MapEntry('maxCapacity', store.maxCapacity.toString()),
    ]);

    if (store.schedule != null) {
      for (int i = 0; i < store.schedule!.length; i++) {
        Schedule schedule = store.schedule![i];

        formData.fields.addAll([
          MapEntry('schedule[$i][day_of_week]',
              getDayOfWeekAbbreviation(schedule.dayOfWeek, "en"))
        ]);
        formData.fields.addAll([
          MapEntry('schedule[$i][open_time]', formatTime(schedule.openTime))
        ]);
        formData.fields.addAll([
          MapEntry('schedule[$i][close_time]', formatTime(schedule.closeTime))
        ]);
      }
    }

    Map<String, dynamic> data =
        await putFormData('$domain/popup/update/${store.id}', formData);
    Logger.debug("### 스토어 수정 $data");
    Logger.debug("### 스토어 수정 $formData");
    return data;
  }

  // 팝업 승인 거절
  static Future<Map<String, dynamic>> postPopupDeny(
      String storeId, String content) async {
    final data = await postData('$domain/admin/popupPendingDeny/',
        {'storeId': storeId, 'denialReason': content});
    Logger.debug("### 팝업 승인 거절 $data");
    return data;
  }

  // 지도 조회용 모든 팝업 조회
  static Future<Map<String, Set<Marker>>> getAllPopupListForMap() async {
    try {
      final List<dynamic> dataList = await getListData('$domain/popup', {});
      List<PopupModel> popupList =
          dataList.map((data) => PopupModel.fromJson(data)).toList();

      Map<String, Set<Marker>> popupMarkersMap = {};

      for (PopupModel popup in popupList) {
        final locationData = await UserApi.getAddress(
          popup.location.toString().split("/")[0] != ""
              ? popup.location.toString().split("/")[0]
              : "서울특별시 강남구 강남대로 지하396",
        );

        var documents = locationData['documents'];
        if (documents != null && documents.isNotEmpty) {
          var firstDocument = documents[0];
          var x = firstDocument['x'].toString();
          var y = firstDocument['y'].toString();

          Marker marker = Marker(
            markerId: '${popupMarkersMap.length + 1}',
            latLng: LatLng(double.parse(y), double.parse(x)),
          );

          if (popupMarkersMap.containsKey(popup.id)) {
            popupMarkersMap[popup.id]!.add(marker);
          } else {
            popupMarkersMap[popup.id.toString()] = {marker};
          }
        } else {
          Logger.debug('No documents found');
        }
      }

      return popupMarkersMap;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to All popup list: $e');
      throw Exception('Failed to All popup list');
    }
  }

  // 추천 팝업 조회
  static Future<List<PopupModel>> getRecommendedPopupList() async {
    try {
      final List<dynamic> dataList = await getListData(
          '$domain/popup/recommendation/${User().userName}', {});
      List<PopupModel> popupList =
          dataList.map((data) => PopupModel.fromJson(data)).toList();
      return popupList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to getRecommendedPopupList popup list: $e');
      throw Exception('Failed to getRecommendedPopupList popup list');
    }
  }

  // 오픈 예정 팝업 조회
  static Future<List<PopupModel>> getWillBeOpenPopupList() async {
    try {
      final List<dynamic> dataList =
          await getListData('$domain/popup/scheduledToOpen', {});
      List<PopupModel> popupList =
          dataList.map((data) => PopupModel.fromJson(data)).toList();
      return popupList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to getWillBeOpenPopupList popup list: $e');
      throw Exception('Failed to getWillBeOpenPopupList popup list');
    }
  }

  // 종료 예정 팝업 조회
  static Future<List<PopupModel>> getWillBeClosePopupList() async {
    try {
      final List<dynamic> dataList =
          await getListData('$domain/popup/scheduledToClose', {});
      List<PopupModel> popupList =
          dataList.map((data) => PopupModel.fromJson(data)).toList();
      return popupList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to getWillBeClosePopupList popup list: $e');
      throw Exception('Failed to getWillBeClosePopupList popup list');
    }
  }

  // 팝업 삭제
  static Future<Map<String, dynamic>> deletePopup(String storeId) async {
    final data = await deleteData('$domain/popup/delete/$storeId', {});
    Logger.debug("### 팝업 삭제 $data");
    return data;
  }

  // 스토어 이름으로 팝업 검색
  static Future<List<PopupModel>> getPopupByName(String storeName) async {
    try {
      final List<dynamic> dataList = await getListData(
          '$domain/popup/searchPopups/?type=storeName&storeName=$storeName',
          {});
      List<PopupModel> popupList =
          dataList.map((data) => PopupModel.fromJson(data)).toList();
      return popupList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch getPopupByName list: $e');
      throw Exception('Failed to fetch getPopupByName list');
    }
  }

  // 카테고리로 팝업 검색
  static Future<List<PopupModel>> getPopupByCategory(int category) async {
    try {
      final List<dynamic> dataList = await getListData(
          '$domain/popup/searchPopups/?type=category&categoryId=$category', {});
      List<PopupModel> popupList =
          dataList.map((data) => PopupModel.fromJson(data)).toList();
      return popupList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch getPopupByCategory list: $e');
      throw Exception('Failed to fetch getPopupByCategory list');
    }
  }
}
