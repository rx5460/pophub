class FundingSupportModel {
  final String? itemId, userName, createdAt;
  final int? fundingId, amount;

  // 기본 생성자
  FundingSupportModel({
    this.itemId,
    this.userName,
    this.amount,
    this.createdAt,
    this.fundingId,
  });

  FundingSupportModel.fromJson(Map<String, dynamic> json)
      : itemId = json['itemId'],
        userName = json['userName'],
        createdAt = json['createdAt'],
        fundingId = json['fundingId'],
        amount = json['amount'];
}
