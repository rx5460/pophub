import 'package:pophub/model/review_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';

class ReviewApi {
  // static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";
  static String domain = "http://3.233.20.5:3000";

// 리뷰 조회 - 팝업별
  static Future<List<ReviewModel>> getReviewListByPopup(String popup) async {
    try {
      final List<dynamic> dataList = await getListData(
          '$domain/popup/getReviews?type=store&storeId=$popup', {});
      List<ReviewModel> reviewList =
          dataList.map((data) => ReviewModel.fromJson(data)).toList();
      return reviewList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch review list: $e');
      throw Exception('Failed to fetch review list');
    }
  }

  // 리뷰 조회 - 사용자별
  static Future<List<ReviewModel>> getReviewListByUser(String userName) async {
    try {
      final List<dynamic> dataList = await getListData(
          '$domain/popup/getReviews?type=user&userName=${User().userName}', {});
      print('$domain/popup/reviews/user/$userName');
      List<ReviewModel> reviewList =
          dataList.map((data) => ReviewModel.fromJson(data)).toList();
      return reviewList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch review list: $e');
      throw Exception('Failed to fetch review list');
    }
  }

  // 리뷰 작성
  static Future<Map<String, dynamic>> postWriteReview(
      String popup, String rating, String content, String userName) async {
    final data = await postData('$domain/popup/review/create/$popup', {
      'userName': userName,
      'reviewRating': rating,
      'reviewContent': content
    });
    print('$domain/popup/review/create/$popup');
    print('userName: $userName,reviewRating: $rating,reviewContent: $content');
    Logger.debug("### 리뷰 작성 $data");
    return data;
  }
}
