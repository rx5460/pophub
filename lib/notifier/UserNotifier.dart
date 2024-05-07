import 'package:flutter/material.dart';

class UserNotifier with ChangeNotifier {
  int _count = 0;
  int get count => _count;
  bool isVerify = false;

  TextEditingController phoneController = TextEditingController();
  TextEditingController verifyController = TextEditingController();
  TextEditingController idController = TextEditingController();

  set count(int value) {
    _count = value;
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}

UserNotifier userNotifier = UserNotifier();
