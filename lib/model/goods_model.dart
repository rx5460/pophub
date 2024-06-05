class GoodsModel {
  int price, quantity;
  final String userName, productName, description;
  final List? image;

  GoodsModel.fromJson(Map<String, dynamic> json)
      : userName = json['user_name'],
        productName = json['product_name'],
        price = json['product_price'],
        description = json['product_description'],
        quantity = json['remaining_quantity'],
        image = json['files'];

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'product_name': productName,
      'product_price': price,
      'product_description': description,
      'remaining_quantity': quantity,
      'files': image,
    };
  }
}
