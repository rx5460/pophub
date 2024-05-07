import 'dart:ffi';

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
          padding: EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)))),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.black)),
);
