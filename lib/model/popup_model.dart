import 'package:pophub/model/schedule_model.dart';

class PopupModel {
  final String? username,
      name,
      location,
      contact,
      description,
      status,
      start,
      end,
      id,
      wait;
  final int? category, mark, veiw;
  final List? image;
  final bool? bookmark;
  final List<Schedule>? schedule; // 새로운 스케줄 리스트 필드

  PopupModel.fromJson(Map<String, dynamic> json)
      : username = json['user_name'],
        name = json['store_name'],
        location = json['store_location'],
        contact = json['store_contact_info'],
        description = json['store_description'],
        status = json['store_status'],
        start = json['store_start_date'],
        end = json['store_end_date'],
        wait = json['store_wait_status'],
        id = json['store_id'],
        category = json['category_id'],
        mark = json['store_mark_number'],
        veiw = json['store_view_count'],
        image = json['imageUrls'],
        bookmark = json['is_bookmarked'],
        schedule = (json['schedule'] as List<dynamic>?)
            ?.map((item) => Schedule.fromJson(item as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'user_name': username,
      'store_name': name,
      'store_location': location,
      'store_contact_info': contact,
      'store_description': description,
      'store_status': status,
      'store_start_date': start,
      'store_end_date': end,
      'store_wait_status': wait,
      'store_id': id,
      'category_id': category,
      'store_mark_number': mark,
      'store_view_count': veiw,
      'imageUrls': image,
      'is_bookmarked': bookmark,
      'schedule': schedule?.map((e) => e.toJson()).toList(),
    };
  }
}
