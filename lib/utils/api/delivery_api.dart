import 'package:pophub/model/delivery_model.dart';
import 'package:pophub/model/tracking_model.dart';
import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';

class DeliveryApi {
  // static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";
  static String domain = "http://3.233.20.5:3000";

  // 운송장 등록
  static Future<Map<String, dynamic>> postTrackingNumber(
      String deliveryId, String courier, String trackingNumber) async {
    final data = await putData('$domain/delivery/createTrackingNumber', {
      'deliveryId': deliveryId,
      'courier': courier,
      'trackingNumber': trackingNumber
    });

    return data;
  }

  // 배송 조회 이름
  static Future<List<DeliveryModel>> getDeliveryListByUser(
      String userName) async {
    try {
      final List<dynamic> dataList = await getListData(
          '$domain/delivery/show/user?userName=$userName&status=All', {});

      Logger.debug("### 배송 조회  $dataList");
      List<DeliveryModel> deliveryList =
          dataList.map((data) => DeliveryModel.fromJson(data)).toList();
      return deliveryList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch deliveryList : $e');
      throw Exception('Failed to fetch deliveryList ');
    }
  }

  // 배송 조회 판매자
  static Future<List<DeliveryModel>> getDeliveryListByPresident(
      String userName, String? StoreId) async {
    try {
      final List<dynamic> dataList = await getListData(
          '$domain/delivery/show/president?userName=$userName&storeId=$StoreId&status=All',
          {});
      Logger.debug("### 배송 조회  $dataList");
      List<DeliveryModel> deliveryList =
          dataList.map((data) => DeliveryModel.fromJson(data)).toList();
      return deliveryList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch deliveryList : $e');
      throw Exception('Failed to fetch deliveryList ');
    }
  }

  // 배송 조회
  static Future<List<DeliveryTrackingModel>> gettracking(
      String courier, int trackingNum) async {
    try {
      final List<dynamic> dataList = await getListData(
          '$domain/delivery/tracker?courier=$courier&trackingNumber=$trackingNum',
          {});
      List<DeliveryTrackingModel> deliveryList =
          dataList.map((data) => DeliveryTrackingModel.fromJson(data)).toList();
      return deliveryList;
    } catch (e) {
      // 오류 처리
      Logger.debug('Failed to fetch deliveryList : $e');
      throw Exception('Failed to fetch deliveryList ');
    }
  }

  // 배송 주문
  static Future<Map<String, dynamic>> postDelivery(
      String userName,
      int addressId,
      String storeId,
      String productId,
      int paymentAmount,
      int quantity) async {
    final data = await postData('$domain/delivery', {
      'userName': userName,
      'addressId': addressId,
      'storeId': storeId,
      'productId': productId,
      'paymentAmount': paymentAmount,
      'quantity': quantity,
    });

    Logger.debug("### 배송 주문 $data");
    return data;
  }
}
