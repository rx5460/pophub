import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pophub/model/goods_model.dart';
import 'package:pophub/model/user.dart';
import 'package:pophub/notifier/GoodsNotifier.dart';
import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';

class GoodsApi {
  // static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";
  static String domain = "http://3.88.120.90:3000";

// 특정 팝업스토어 굿즈 조회
  static Future<List<GoodsModel>> getPopupGoodsList(String popup) async {
    try {
      final List<dynamic> dataList =
          await getListData('$domain/product/store/$popup', {});
      List<GoodsModel> goodsList =
          dataList.map((data) => GoodsModel.fromJson(data)).toList();
      return goodsList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch goods list: $e');
      throw Exception('Failed to fetch goods list');
    }
  }

  // 굿즈 등록
  static Future<Map<String, dynamic>> postGoodsAdd(
      GoodsNotifier goods, String storeId) async {
    FormData formData = FormData();

    // 파일 추가
    for (var imageMap in goods.images) {
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

    formData.fields.addAll([
      MapEntry('user_name', goods.userName),
      MapEntry('product_name', goods.productName),
      MapEntry('product_price', goods.price.toString()),
      MapEntry('product_description', goods.description),
      MapEntry('remaining_quantity', goods.quantity.toString()),
    ]);

    Map<String, dynamic> data =
        await postFormData('$domain/product/create/$storeId', formData);
    Logger.debug("### 굿즈 추가 $data");
    return data;
  }

  // 굿즈 수정
  static Future<Map<String, dynamic>> putGoodsModify(
      GoodsNotifier goods, String productId) async {
    FormData formData = FormData();

    // 파일 추가
    for (var imageMap in goods.images) {
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

    formData.fields.addAll([
      MapEntry('userName', User().userName),
      MapEntry('productName', goods.productName),
      MapEntry('productPrice', goods.price.toString()),
      MapEntry('productDescription', goods.description),
      MapEntry('remainingQuantity', goods.quantity.toString()),
    ]);

    Map<String, dynamic> data =
        await putFormData('$domain/product/update/$productId', formData);
    Logger.debug("### 굿즈 수정 $data");
    return data;
  }

  // 특정 팝업 굿즈 상세 조회
  static Future<GoodsModel> getPopupGoodsDetail(String productId) async {
    final data = await getListData('$domain/product/view/$productId', {});
    // 뒤에 userId 추가 예정 / 스웨거에는 userId 포함(필수체크 x)
    Logger.debug("### 특정 팝업 굿즈 상세 조회 $data");

    GoodsModel goodsModel = GoodsModel.fromJson(data[0]);
    return goodsModel;
  }

  // 굿즈 삭제
  static Future<Map<String, dynamic>> deleteGoods(String productId) async {
    final data = await deleteData('$domain/product/delete/$productId', {});
    Logger.debug("### 굿즈 삭제 $data");
    return data;
  }
}
