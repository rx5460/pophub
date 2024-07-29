import 'package:pophub/model/notice_model.dart';
import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';

class NoticeApi {
  static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";

// 전체 공지사항 조회
  static Future<List<NoticeModel>> getNoticeList() async {
    final dataList = await getListData('$domain/admin/notice', {});
    List<NoticeModel> noticeList =
        dataList.map((data) => NoticeModel.fromJson(data)).toList();
    Logger.debug("### 공지사항 조회 $noticeList");
    return noticeList;
  }

  static Future<dynamic> getFirstItem(String url) async {
    final List<dynamic> dataList = await getListData(url, {});
    if (dataList.isNotEmpty) {
      return dataList.first;
    } else {
      throw Exception('Data list is empty');
    }
  }
}
