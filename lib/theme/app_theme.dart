import 'package:flutter/material.dart';
import 'package:yjg/theme/pallete.dart';

class AppTheme {

  static ThemeData theme = ThemeData.light().copyWith(

    // 배경 색상 지정
    scaffoldBackgroundColor: Pallete.backgroundColor,

    // 앱바 테마 지정
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.mainColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Pallete.appBarTitleColor,
        fontWeight: FontWeight.w200,
        fontSize: 20,
      )
    )
  );
}