import 'package:intl/intl.dart';

class DeliveryModel {
  final String deliveryId;
  String userName;
  final String address;
  final String storeId;
  final String productId;
  final int paymentAmount;
  final int quantity;
  final String? courier;
  final String? trackingNumber;
  final DateTime orderDate;
  final String status;
  final String? cancelReason;

  DeliveryModel({
    required this.deliveryId,
    required this.userName,
    required this.address,
    required this.storeId,
    required this.productId,
    required this.paymentAmount,
    required this.quantity,
    this.courier,
    this.trackingNumber,
    required this.orderDate,
    required this.status,
    this.cancelReason,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      deliveryId: json['delivery_id'],
      userName: json['user_name'],
      address: json['address'],
      storeId: json['store_id'],
      productId: json['product_id'],
      paymentAmount: json['payment_amount'],
      quantity: json['quantity'],
      courier: json['courier'],
      trackingNumber: json['tracking_number'],
      orderDate: DateTime.parse(json['order_date']),
      status: json['status'],
      cancelReason: json['cancel_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'delivery_id': deliveryId,
      'user_name': userName,
      'address': address,
      'store_id': storeId,
      'product_id': productId,
      'payment_amount': paymentAmount,
      'quantity': quantity,
      'courier': courier,
      'tracking_number': trackingNumber,
      'order_date':
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(orderDate),
      'status': status,
      'cancel_reason': cancelReason,
    };
  }
}
