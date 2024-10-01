import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pophub/model/funding_model.dart';
import 'package:pophub/model/funding_support_model.dart';
import 'package:pophub/model/fundingitem_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';

class FundingApi {
  // static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";
  static String domain = "http://3.88.120.90:3000";

  // 내 펀딩 리스트 조회
  static Future<List<dynamic>> getMyFunding() async {
    final data =
        await getListData('$domain/funding?userName=${User().userName}', {});
    print(data);
    Logger.debug("### 내 펀딩 조회 $data");
    return data;
  }

  //펀딩 아이템 생성
  static Future<Map<String, dynamic>> postFundingItemAdd(
      FundingItemModel item, String funding) async {
    FormData formData = FormData();

    // 파일 추가
    for (var imageMap in item.images!) {
      if (imageMap['type'] == 'file') {
        var file = imageMap['data'] as File;
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last),
        ));
      } else if (imageMap['type'] == 'url') {
        var url = imageMap['data'] as String;
        var response = await Dio().get<List<int>>(url,
            options: Options(responseType: ResponseType.bytes));
        formData.files.add(MapEntry(
          'image',
          MultipartFile.fromBytes(response.data!,
              filename: url.split('/').last),
        ));
      }
    }

    // 펀딩 기본 정보 추가
    formData.fields.addAll([
      MapEntry('fundingId', funding),
      MapEntry('userName', User().userName),
      MapEntry('title', item.itemName ?? ''),
      MapEntry('count', item.count.toString()),
      MapEntry('content', item.content ?? ''),
      MapEntry('amount', item.amount?.toString() ?? '0'),
    ]);
    for (var field in formData.fields) {
      print("${field.key}: ${field.value}");
    }
    for (var file in formData.files) {
      print("File Field: ${file.key}, File Name: ${file.value.filename}");
    }
    // 서버에 데이터 전송
    final data = await postFormData('$domain/funding/item/create', formData);
    print(data);

    Logger.debug("### 펀딩 아이템 추가 $data");
    return data;
  }

  //펀딩 생성
  static Future<Map<String, dynamic>> postFundingAdd(
      FundingModel funding) async {
    FormData formData = FormData();

    // 파일 추가
    for (var imageMap in funding.images!) {
      if (imageMap['type'] == 'file') {
        var file = imageMap['data'] as File;
        formData.files.add(MapEntry(
          'images',
          await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last),
        ));
      } else if (imageMap['type'] == 'url') {
        var url = imageMap['data'] as String;
        var response = await Dio().get<List<int>>(url,
            options: Options(responseType: ResponseType.bytes));
        formData.files.add(MapEntry(
          'images',
          MultipartFile.fromBytes(response.data!,
              filename: url.split('/').last),
        ));
      }
    }

    // 펀딩 기본 정보 추가
    formData.fields.addAll([
      MapEntry('userName', User().userName),
      MapEntry('title', funding.title ?? ''),
      MapEntry('content', funding.content ?? ''),
      MapEntry('amount', funding.amount?.toString() ?? '0'),
      MapEntry('openDate', funding.openDate ?? ''),
      MapEntry('closeDate', funding.closeDate ?? ''),
      MapEntry('paymentDate', funding.closeDate ?? '')
    ]);
    for (var field in formData.fields) {
      print("${field.key}: ${field.value}");
    }
    for (var file in formData.files) {
      print("File Field: ${file.key}, File Name: ${file.value.filename}");
    }
    // 서버에 데이터 전송
    final data = await postFormData('$domain/funding/create', formData);
    print(data);

    Logger.debug("### 펀딩 추가 $data");
    return data;
  }

  //아이템 생성
  static Future<Map<String, dynamic>> postItemAdd(FundingItemModel item) async {
    FormData formData = FormData();

    // 파일 추가

    if (item.images != null) {
      for (var imageMap in item.images!) {
        if (imageMap['type'] == 'file') {
          var file = imageMap['data'] as File;
          formData.files.add(MapEntry(
            'images',
            await MultipartFile.fromFile(file.path,
                filename: file.path.split('/').last),
          ));
        } else if (imageMap['type'] == 'url') {
          var url = imageMap['data'] as String;
          var response = await Dio().get<List<int>>(url,
              options: Options(responseType: ResponseType.bytes));
          formData.files.add(MapEntry(
            'images',
            MultipartFile.fromBytes(response.data!,
                filename: url.split('/').last),
          ));
        }
      }
    }

    // 아이템 기본 정보 추가
    formData.fields.addAll([
      MapEntry('fundingId', item.fundingId!),
      MapEntry('userName', User().userName),
      MapEntry('itemName', item.itemName ?? ''),
      MapEntry('content', item.content ?? ''),
      MapEntry('count', item.count?.toString() ?? '0'),
      MapEntry('amount', item.amount?.toString() ?? '0'),
      MapEntry('openDate', item.openDate ?? ''),
      MapEntry('closeDate', item.closeDate ?? ''),
      MapEntry('paymentDate', item.paymentDate!),
      // // 문자열을 DateTime으로 변환 후 ISO 8601 형식으로 변환
      // MapEntry(
      //     'openDate',
      //     item.openDate != null
      //         ? DateTime.parse(item.openDate!).toIso8601String()
      //         : ''),
      // MapEntry(
      //     'closeDate',
      //     item.closeDate != null
      //         ? DateTime.parse(item.closeDate!).toIso8601String()
      //         : ''),
      // MapEntry(
      //     'paymentDate',
      //     item.paymentDate != null
      //         ? DateTime.parse(item.paymentDate!).toIso8601String()
      //         : ''),
    ]);

    // 필드 출력 (디버깅용)
    for (var field in formData.fields) {
      print("${field.key}: ${field.value}");
    }

    // 파일 출력 (디버깅용)
    for (var file in formData.files) {
      print("File Field: ${file.key}, File Name: ${file.value.filename}");
    }

    // 서버에 데이터 전송
    final data = await postFormData('$domain/funding/item/create', formData);
    print(data);

    Logger.debug("### 아이템 추가 $data");
    return data;
  }

  // 특정 펀딩 아이템 조회
  static Future<List<FundingItemModel>> getFundingItemList(
      String funding) async {
    try {
      final List<dynamic> dataList =
          await getListData('$domain/funding/item?fundingId=$funding', {});
      List<FundingItemModel> itemList =
          dataList.map((data) => FundingItemModel.fromJson(data)).toList();
      return itemList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch itme list: $e');
      throw Exception('Failed to fetch itme list');
    }
  }

  // 펀딩 조회
  static Future<List<FundingModel>> getFundingList() async {
    try {
      final List<dynamic> dataList = await getListData('$domain/funding', {});
      List<FundingModel> fundingList =
          dataList.map((data) => FundingModel.fromJson(data)).toList();
      return fundingList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch funding list: $e');
      throw Exception('Failed to fetch funding list');
    }
  }

  // 내 펀딩 조회
  static Future<List<FundingModel>> getMyFundingList() async {
    try {
      final List<dynamic> dataList =
          await getListData('$domain/funding?userName=${User().userName}', {});
      List<FundingModel> fundingList =
          dataList.map((data) => FundingModel.fromJson(data)).toList();
      return fundingList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch funding list: $e');
      throw Exception('Failed to fetch funding list');
    }
  }

  // 펀딩 참여
  static Future<Map<String, dynamic>> postFundingSupport(
      String item, String amount) async {
    final data = await postData('$domain/funding/support/create',
        {'itemId': item, 'amount': amount, 'userName': User().userName});
    Logger.debug("### 펀딩 참여 $data");
    return data;
  }

  // 펀딩 참여 조회
  static Future<List<FundingSupportModel>> getFundingSupport() async {
    try {
      final List<dynamic> dataList = await getListData(
          '$domain/funding/support?userName=${User().userName}', {});
      List<FundingSupportModel> supportList =
          dataList.map((data) => FundingSupportModel.fromJson(data)).toList();
      return supportList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch support list: $e');
      throw Exception('Failed to fetch support list');
    }
  }

  // 아이템조회 : itemId
  static Future<List<FundingItemModel>> getFundingItem(String item) async {
    try {
      final List<dynamic> dataList =
          await getListData('$domain/funding/item?itemId=$item', {});
      List<FundingItemModel> itemList =
          dataList.map((data) => FundingItemModel.fromJson(data)).toList();
      return itemList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch itme list: $e');
      throw Exception('Failed to fetch itme list');
    }
  }
}
