import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xff6874E8),
    secondary: Color(0xff548c2f),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xffdef0d1),
    onSecondaryContainer: Color(0xff131F0a),
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xffcfd2ff),
    primary: Color(0xffcfd2ff),
    onPrimary: Color(0xff1529e8),
    primaryContainer: Color(0xff5563e8),
    onPrimaryContainer: Color(0xffe6e7fd),
    secondary: Color(0xffd3ebc1),
    onSecondary: Color(0xff253e14),
    secondaryContainer: Color(0xff4B7b28),
    onSecondaryContainer: Color(0xffe9f5e0),
    onBackground: Color(0xffe6e1e5),
  ),
);
