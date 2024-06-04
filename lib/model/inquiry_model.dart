class InquiryModel {
  final int inquiryId;
  final String userName;
  final int categoryId;
  final String category;
  final String title;

  InquiryModel.fromJson(Map<String, dynamic> json)
      : inquiryId = json['inquiryId'],
        userName = json['userName'],
        categoryId = json['categoryId'],
        category = json['category'],
        title = json['title'];

  Map<String, dynamic> toJson() {
    return {
      'inquiryId': inquiryId,
      'userName': userName,
      'categoryId': categoryId,
      'category': category,
      'title': title
    };
  }
}
