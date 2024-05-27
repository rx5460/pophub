import 'package:flutter/material.dart';
import 'dart:io';

class Schedule {
  final String dayOfWeek;
  final String openTime;
  final String closeTime;

  Schedule(
      {required this.dayOfWeek,
      required this.openTime,
      required this.closeTime});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      dayOfWeek: json['day_of_week'],
      openTime: json['open_time'],
      closeTime: json['close_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day_of_week': dayOfWeek,
      'open_time': openTime,
      'close_time': closeTime,
    };
  }
}

class StoreModel with ChangeNotifier {
  String name = '';
  String description = '';
  String location = '';
  String contact = '';
  String category = '';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  List<File> images = [];
  int maxCapacity = 0;
  List<Schedule> schedule = [];

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

  void removeImage(File image) {
    images.remove(image);
    notifyListeners();
  }

  void addSchedule(Schedule newSchedule) {
    schedule.add(newSchedule);
    notifyListeners();
  }

  void updateSchedule(String dayOfWeek, String openTime, String closeTime) {
    for (var s in schedule) {
      if (s.dayOfWeek == dayOfWeek) {
        s = Schedule(
            dayOfWeek: dayOfWeek, openTime: openTime, closeTime: closeTime);
        notifyListeners();
        return;
      }
    }
    schedule.add(Schedule(
        dayOfWeek: dayOfWeek, openTime: openTime, closeTime: closeTime));
    notifyListeners();
  }
}
