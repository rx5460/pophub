class FundingModel {
  final String? userName,
      title,
      content,
      status,
      openDate,
      closeDate,
      fundingId;
  final int? amount, donation;
  final List? images;

  // 기본 생성자
  FundingModel({
    this.userName,
    this.title,
    this.content,
    this.status,
    this.openDate,
    this.closeDate,
    this.fundingId,
    this.amount,
    this.donation,
    this.images,
  });

  // fromJson 생성자
  FundingModel.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        title = json['title'],
        content = json['content'],
        status = json['status'],
        openDate = json['openDate'],
        closeDate = json['closeDate'],
        fundingId = json['fundingId'],
        amount = json['amount'],
        donation = json['donation'],
        images = json['images'];
}
