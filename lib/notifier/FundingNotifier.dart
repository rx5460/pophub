import 'package:flutter/material.dart';

class FundingModel with ChangeNotifier {
  String name = '';
  String description = '';
  String location = '';
  String locationDetail = '';
  String contact = '';
  String category = '';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  List<Map<String, dynamic>> images = [];
  int maxCapacity = 0;

  String id = '';

  void addImage(Map<String, dynamic> image) {
    images.add(image);
    notifyListeners();
  }

  void removeImage(Map<String, dynamic> image) {
    images.remove(image);
    notifyListeners();
  }
}
