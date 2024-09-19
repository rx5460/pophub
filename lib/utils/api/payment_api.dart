import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';

class PaymentApi {
  // static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";
  static String domain = "http://3.88.120.90:3000";

// 결제
  static Future<Map<String, dynamic>> postPay(
      String userName,
      String itemName,
      int quantity,
      int totalAmount,
      int vatAmount,
      int taxFreeAmount,
      String storeId,
      String productId) async {
    final data = await postData('$domain/pay', {
      'userName': userName,
      "itemName": itemName,
      "quantity": quantity,
      "totalAmount": totalAmount,
      "vatAmount": vatAmount,
      "taxFreeAmount": taxFreeAmount,
      "storeId": storeId,
      "productId": productId
    });
    Logger.debug("### 결제 $data");
    return data;
  }
}
