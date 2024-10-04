class Achievement {
  final String title;
  final String description;
  final String imageUrl;
  final bool isUnlocked;

  Achievement(
      {required this.title,
      required this.description,
      required this.imageUrl,
      this.isUnlocked = false});

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      isUnlocked: json['isUnlocked'] ?? false,
    );
  }
}
