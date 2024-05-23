import 'package:flutter/material.dart';
import 'dart:io';

class StoreModel with ChangeNotifier {
  String name = '';
  String description = '';
  String location = '';
  String contact = '';
  String category = '';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  List<File> images = [];

  void updateLocation(String newLocation) {
    location = newLocation;
    notifyListeners();
  }

  void updateStartDate(DateTime newStartDate) {
    startDate = newStartDate;
    notifyListeners();
  }

  void updateEndDate(DateTime newEndDate) {
    endDate = newEndDate;
    notifyListeners();
  }

  void addImage(File image) {
    images.add(image);
    notifyListeners();
  }
}
