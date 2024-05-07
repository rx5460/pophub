import 'package:flutter/material.dart';

var theme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  fontFamily: 'NanumGothicCoding',
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Colors.black,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white),
          backgroundColor: const Color(0xffadd8e6),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.white),
          padding: const EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.black)),
  inputDecorationTheme: const InputDecorationTheme(
    // 입력 필드 스타일 설정
    contentPadding: EdgeInsets.all(10),
    fillColor: Color(0xffadd8e6),
    hintStyle: TextStyle(color: Colors.grey),
    labelStyle: TextStyle(color: Colors.blue),
  ),
);
