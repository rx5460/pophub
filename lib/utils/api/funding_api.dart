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
    Logger.debug("### 내 펀딩 조회 $data");
    return data;
  }
}
