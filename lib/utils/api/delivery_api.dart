import 'package:pophub/model/address_model.dart';
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

  // 주소 수정
  static Future<Map<String, dynamic>> putAddress(
      int? addressId, String address) async {
    final data = await putData('$domain/delivery/address/update',
        {'addressId': addressId, 'address': address});

    Logger.debug("### 주소 수정 $data");
    return data;
  }

  // 주소 가져오기
  static Future<AddressModel> getAddress(String userName) async {
    final data =
        await getListData('$domain/delivery/address/show/$userName', {});
    Logger.debug("### 주소 가져오기 $data");

    AddressModel addressModel = AddressModel.fromJson(data[0]);
    return addressModel;
  }
}
