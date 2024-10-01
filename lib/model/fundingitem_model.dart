class FundingItemModel {
  final String? itemId,
      fundingId,
      userName,
      itemName,
      content,
      openDate,
      closeDate,
      paymentDate;
  final int? count, amount;
  final List? images;

  // 기본 생성자
  FundingItemModel({
    this.itemId,
    this.fundingId,
    this.content,
    this.userName,
    this.itemName,
    this.count,
    this.amount,
    this.images,
    this.openDate,
    this.closeDate,
    this.paymentDate,
  });

  FundingItemModel.fromJson(Map<String, dynamic> json)
      : itemId = json['itemId'],
        fundingId = json['fundingId'],
        userName = json['userName'],
        itemName = json['itemName'],
        content = json['content'],
        count = json['count'],
        amount = json['amount'],
        images = json['images'],
        openDate = json['openDate'],
        closeDate = json['closeDate'],
        paymentDate = json['paymentDate'];
}
