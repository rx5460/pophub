class FundingModel {
  final String? userName, title, content, status, openDate, closeDate;
  final int? fundingId, amount, donation;
  final List? images;

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
