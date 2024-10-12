class VisitModel {
  final String? userName, storeId, reservationDate, storeName, images;
  final int? calendarId;

  VisitModel.fromJson(Map<String, dynamic> json)
      : userName = json['user_name'],
        storeId = json['store_id'],
        reservationDate = json['reservation_date'],
        storeName = json['store_name'],
        images = json['images'],
        calendarId = json['calendar_id'];
}
