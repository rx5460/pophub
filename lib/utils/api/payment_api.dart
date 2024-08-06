import 'package:pophub/utils/http.dart';
import 'package:pophub/utils/log.dart';

class PaymentApi {
  // static String domain = "https://pophub-fa05bf3eabc0.herokuapp.com";
  static String domain = "http://3.88.120.90:3000";

// 결제
  static Future<Map<String, dynamic>> postPay(String userId, String itemName,
      int quantity, int totalAmount, int vatAmount, int taxFreeAmount) async {
    final data = await postData('$domain/pay', {
      'userId': userId,
      "itemName": itemName,
      "quantity": quantity,
      "totalAmount": totalAmount,
      "vatAmount": vatAmount,
      "taxFreeAmount": taxFreeAmount
    });
    Logger.debug("### 결제 $data");
    return data;
  }
}
