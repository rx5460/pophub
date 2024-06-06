class ReservationModel {
  final String? store, date, time;
  final int? max, current;
  final bool? status;

  ReservationModel.fromJson(Map<String, dynamic> json)
      : store = json['store_id'],
        max = json['max_capacity'],
        current = json['current_capacity'],
        status = json['status'],
        date = json['reservatuin_date'],
        time = json['reservatuin_time'];
}
