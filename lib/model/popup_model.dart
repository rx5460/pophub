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
        image = json['imageUrls'];
}
