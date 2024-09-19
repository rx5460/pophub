class AdModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? creatorId;
  final DateTime? startDate;
  final String? content;
  final DateTime? endDate;

  AdModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.createdAt,
      this.updatedAt,
      this.creatorId,
      this.startDate,
      this.content,
      this.endDate});

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      creatorId: json['creatorId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'creatorId': creatorId,
    };
  }
}
