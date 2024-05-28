import 'package:flutter/material.dart';

var theme = ThemeData(
  appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
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
          minimumSize: const Size(double.infinity, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.black)),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFFFFFFF),
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xffd9d9d9)),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    errorStyle: const TextStyle(color: Colors.red),
  ),
);
