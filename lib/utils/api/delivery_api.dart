import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';

class DeliveryApi {
  // static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";
  static String domain = "http://3.88.120.90:3000";

  // 운송장 등록
  static Future<Map<String, dynamic>> postTrackingNumber(
      String deliveryId, String courier, String trackingNumber) async {
    final data = await putData('$domain/delivery/createTrackingNumber', {
      'deliveryId': deliveryId,
      'courier': courier,
      'trackingNumber': trackingNumber
    });

    Logger.debug("### 운송장 등록 $data");
    return data;
  }

  // 배송 주문
  static Future<Map<String, dynamic>> postDelivery(
      String userName,
      int addressId,
      String storeId,
      String productId,
      int paymentAmount,
      int quantity) async {
    final data = await putData('$domain/delivery', {
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
