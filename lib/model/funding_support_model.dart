class FundingSupportModel {
  final String? itemId, userName, createdAt, itemName, fundingName;
  final int? supportId, amount, count;

  // 기본 생성자
  FundingSupportModel({
    this.itemId,
    this.userName,
    this.amount,
    this.createdAt,
    this.supportId,
    this.itemName,
    this.fundingName,
    this.count,
  });

  FundingSupportModel.fromJson(Map<String, dynamic> json)
      : itemId = json['itemId'],
        userName = json['userName'],
        createdAt = json['createdAt'],
        supportId = json['supportId'],
        amount = json['amount'],
        count = json['count'],
        itemName = json['itemName'],
        fundingName = json['fundingName'];
}
