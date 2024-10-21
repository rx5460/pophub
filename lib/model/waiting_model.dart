class WaitingModel {
  final String? reservationId, userName, storeId, status;
  final int? capacity;

  WaitingModel.fromJson(Map<String, dynamic> json)
      : reservationId = json['reservation_id'],
        userName = json['user_name'],
        storeId = json['store_id'],
        status = json['status'],
        capacity = json['capacity'];
}
