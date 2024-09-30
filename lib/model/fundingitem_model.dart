class FundingItemModel {
  final String? itemId, fundingId, userName, itemName, content;
  final int? count, amount;
  final List? images;

  // fromJson 생성자
  FundingItemModel.fromJson(Map<String, dynamic> json)
      : itemId = json['itemId'],
        fundingId = json['fundingId'],
        userName = json['userName'],
        itemName = json['itemName'],
        content = json['content'],
        count = json['count'],
        amount = json['amount'],
        images = json['images'];
}
