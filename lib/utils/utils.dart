import 'package:flutter/material.dart';
import 'package:pophub/screen/custom/custom_alert.dart';

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
