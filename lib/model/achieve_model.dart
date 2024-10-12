class Achievement {
  final int achieveId;
  final String achieveTitle;
  final String userName;
  final DateTime completeAt;

  Achievement({
    required this.achieveId,
    required this.achieveTitle,
    required this.userName,
    required this.completeAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      achieveId: json['achieveId'],
      achieveTitle: json['achieveTitle'],
      userName: json['userName'],
      completeAt: DateTime.parse(json['completeAt']),
    );
  }
}
