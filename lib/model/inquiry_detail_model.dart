class InquiryDetailModel {
  final int inquiryId;
  final String userName;
  final int categoryId;
  final String category;
  final String title;
  final String content;
  final String writeDate;
  final String answerStatus;
  final String? image;

  InquiryDetailModel.fromJson(Map<String, dynamic> json)
      : inquiryId = json['inquiryId'],
        userName = json['userName'],
        categoryId = json['categoryId'],
        category = json['category'],
        title = json['title'],
        content = json['content'],
        writeDate = json['writeDate'],
        answerStatus = json['answerStatus'],
        image = json['image'];

  Map<String, dynamic> toJson() {
    return {
      'inquiryId': inquiryId,
      'userName': userName,
      'categoryId': categoryId,
      'category': category,
      'title': title,
      'content': content,
      'writeDate': writeDate,
      'answerStatus': answerStatus,
      'image': image,
    };
  }
}
