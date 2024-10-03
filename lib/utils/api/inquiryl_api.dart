import 'package:pophub/model/answer_model.dart';
import 'package:pophub/model/inquiry_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';

class InquiryApi {
  // static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";
  static String domain = "http://3.88.120.90:3000";

// 문의 내역
  static Future<List<InquiryModel>> getInquiryList(String userName) async {
    try {
      final List<dynamic> dataList = await getListData(
          '$domain/user/inquiry/search?userName=$userName', {});
      Logger.debug("### 문의 내역 조회 $dataList");

      List<InquiryModel> inquiryList =
          dataList.map((data) => InquiryModel.fromJson(data)).toList();
      return inquiryList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch inquiry list: $e');
      throw Exception('Failed to fetch inquiry list');
    }
  }

  // 문의내역 추가 (이미지 o)
  static Future<Map<String, dynamic>> postInquiryAddWithImage(
      String title, String content, String category, image) async {
    final data = await postDataWithImage(
        '$domain/user/inquiry/create',
        {
          'userName': User().userName,
          'categoryId': category,
          'title': title,
          'content': content
        },
        'file',
        image);
    Logger.debug("### 문의내역 추가 이미지o $data");
    return data;
  }

  // 문의내역 추가 (이미지 x)
  static Future<Map<String, dynamic>> postInquiryAdd(
      String title, String content, String category) async {
    final data = await postData('$domain/user/inquiry/create', {
      'userName': User().userName,
      'categoryId': category,
      'title': title,
      'content': content
    });
    Logger.debug("### 문의내역 추가 이미지x $data");
    return data;
  }

  // 문의 내역 상세 조회
  static Future<InquiryModel> getInquiry(int inquiryId) async {
    final data =
        await getData('$domain/user/answer/search?inquiryId=$inquiryId', {});
    Logger.debug("### 문의 내역 상세 조회 $data");

    InquiryModel inquiryModel = InquiryModel.fromJson(data);
    return inquiryModel;
  }

  // 문의 답변
  static Future<Map<String, dynamic>> postInquiryAnswer(
      int inquiryId, String content) async {
    final data = await postData('$domain/admin/answer/', {
      'inquiryId': inquiryId,
      'userName': User().userName,
      'content': content
    });
    Logger.debug("### 문의 답변 $data");
    return data;
  }

  // 문의 내역 전체 조회
  static Future<List<InquiryModel>> getAllInquiryList() async {
    try {
      final List<dynamic> dataList =
          await getListData('$domain/admin/inquiry/search', {});
      Logger.debug("### 문의 내역 전체 조회 $dataList");

      List<InquiryModel> inquiryList =
          dataList.map((data) => InquiryModel.fromJson(data)).toList();
      return inquiryList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch inquiry list: $e');
      throw Exception('Failed to fetch inquiry list');
    }
  }

  // 답변 조회
  static Future<AnswerModel> getAnswer(int inquiryId) async {
    final data =
        await getData('$domain/user/anwser/search/?inquiryId=$inquiryId', {});
    Logger.debug("### 답변 조회 $data");

    AnswerModel answerModel = AnswerModel.fromJson(data);
    return answerModel;
  }
}
