class PointModel {
  final String userName;
  final int pointScore;
  final String description;
  final String calcul;

  PointModel({
    required this.userName,
    required this.pointScore,
    required this.description,
    required this.calcul,
  });

  factory PointModel.fromJson(Map<String, dynamic> json) {
    return PointModel(
      userName: json['userName'],
      pointScore: json['pointScore'],
      description: json['description'],
      calcul: json['calcul'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'point_score': pointScore,
      'description': description,
      'calcul': calcul,
    };
  }
}
