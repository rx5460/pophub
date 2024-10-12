import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pophub/screen/custom/custom_alert.dart';


import 'package:easy_localization/easy_localization.dart';
bool isValidPhoneNumber(String input) {
  // 숫자와 공백을 제외한 모든 문자를 제거
  String digits = input.replaceAll(RegExp(r'\D'), '');

  // 전화번호의 길이가 10자리 이상 15자리 이하인지 확인
  if (digits.length < 10 || digits.length > 15) {
    return false;
  }

  // 정규식 패턴을 사용하여 전화번호 유효성을 검사
  // 이 정규식은 다양한 형식의 전화번호를 수용합니다 (예: +1-555-555-5555, 555-555-5555, 5555555555 등)
  RegExp regExp = RegExp(r'^\+?\d{0,3}?\-?\d{3}\-?\d{3}\-?\d{4}$');
  return regExp.hasMatch(digits);
}

void showAlert(BuildContext context, String title, String content,
    VoidCallback onPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialogWidget(
        title: title,
        content: content,
        onPressed: onPressed,
      );
    },
  );
}

String getDayOfWeekAbbreviation(String dayOfWeek, String lang) {
  if (lang == "ko") {
    switch (dayOfWeek.toLowerCase()) {
      case 'monday':
      case 'mon':
        return ('monday').tr();
      case 'tuesday':
      case 'tue':
        return ('tuesday').tr();
      case 'wednesday':
      case 'wed':
        return ('wednesday').tr();
      case 'thursday':
      case 'thu':
        return ('thursday').tr();
      case 'friday':
      case 'fri':
        return ('friday').tr();
      case 'saturday':
      case 'sat':
        return ('saturday').tr();
      case 'sunday':
      case 'sun':
        return ('sunday').tr();
      default:
        return dayOfWeek;
    }
  } else {
    switch (dayOfWeek.toLowerCase()) {
      case "monday":
        return "Mon";
      case "tuesday":
        return "Tue";
      case "wednesday":
        return "Wed";
      case "thursday":
        return "Thu";
      case "friday":
        return "Fri";
      case "saturday":
        return "Sat";
      case "sunday":
        return "Sun";
      default:
        return dayOfWeek;
    }
  }
}

String formatTime(String timeString) {
  if (timeString.contains(('city').tr()) && timeString.contains(('minute').tr())) {
    List<String> timeParts = timeString.split(('city').tr());
    int hour = int.parse(timeParts[0]);
    timeParts = timeParts[1].split(('minute').tr());
    int.parse(timeParts[0]);

    return '${hour.toString().padLeft(2, '0')}:00';
  } else {
    List<String> timeParts = timeString.split(':');
    int hour = int.parse(timeParts[0]);
    int.parse(timeParts[1]);

    return '${hour.toString().padLeft(2, '0')}:00';
  }
}

String generateNickname() {
  const length = 8;
  const characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  String generatedNickname = String.fromCharCodes(Iterable.generate(
    length,
    (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
  return generatedNickname;
}

String formatNumber(int number) {
  final formatter = NumberFormat('#,###');
  return formatter.format(number);
}
