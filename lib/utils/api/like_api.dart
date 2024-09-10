import 'package:pophub/model/like_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';

class LikeApi {
  // static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";
  static String domain = "http://3.88.120.90:3000";

  // 찜 페이지 조회
  static Future<List<LikeModel>> getLikePopup() async {
    try {
      final List<dynamic> dataList =
          await getListData('$domain/popup/likeUser/${User().userName}', {});

      if (dataList.toString().contains("존재하지")) {
        List<LikeModel> likeList = [];
        return likeList;
      }
      List<LikeModel> likeList =
          dataList.map((data) => LikeModel.fromJson(data)).toList();
      return likeList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to getLikePopup popup list: $e');
      throw Exception('Failed to getLikePopup popup list');
    }
  }
}
