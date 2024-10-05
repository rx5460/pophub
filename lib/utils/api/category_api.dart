import 'package:pophub/model/category_model.dart';
import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';

class CategoryApi {
  // static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";
  static String domain = "http://3.233.20.5:3000";

  // 카테고리 리스트 조회
  static Future<List<CategoryModel>> getCategoryList() async {
    final dataList = await getListData('$domain/admin/category', {});
    List<CategoryModel> categoryList =
        dataList.map((data) => CategoryModel.fromJson(data)).toList();
    Logger.debug("### 카테고리 리스트 조회 $dataList");
    return categoryList;
  }
}
