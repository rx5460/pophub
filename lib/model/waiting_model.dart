class WaitingModel {
  final List<WaitingResultModel> result;
  final int count;

  WaitingModel.fromJson(Map<String, dynamic> json)
      : result = (json['result'] as List)
            .map((item) => WaitingResultModel.fromJson(item))
            .toList(),
        count = json['count'];
}

class WaitingResultModel {
  final String? reservationId, userName, storeId, status, phoneNumber;
  final int? capacity, position;
  final DateTime? createdAt;

  WaitingResultModel.fromJson(Map<String, dynamic> json)
      : reservationId = json['reservation_id'],
        userName = json['user_name'],
        storeId = json['store_id'],
        status = json['status'],
        capacity = json['capacity'],
        phoneNumber = json['phone_number'],
        position = json['position'],
        createdAt = DateTime.tryParse(json['created_at'] ?? '');
}
