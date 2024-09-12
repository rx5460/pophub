class AddressModel {
  final int? addressId;
  final String? userName;
  final String? address;
  final String? createAt;

  AddressModel.fromJson(Map<String, dynamic> json)
      : addressId = json['address_id'],
        userName = json['user_name'],
        address = json['address'],
        createAt = json['create_at'];

  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'user_name': userName,
      'address': address,
      'create_at': createAt,
    };
  }
}
