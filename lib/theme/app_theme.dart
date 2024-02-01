import 'package:flutter/material.dart';
import 'package:yjg/theme/palette.dart';

class AppTheme {

  static ThemeData theme = ThemeData.light().copyWith(
    // 배경 색상 지정
    scaffoldBackgroundColor: Palette.backgroundColor,

    // 앱바 테마 지정
    appBarTheme: const AppBarTheme(
      backgroundColor: Palette.mainColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Palette.appBarTitleColor,
        fontWeight: FontWeight.w200,
        fontSize: 20,
      )
    ),

    // 폰트
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontFamily: 'PretendardRegular',  // 폰트 설정
        fontSize: 16,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'PretendardSemiBold',  // 폰트 설정
        fontSize: 14,
        color: Colors.black,
      ),
      bodySmall: TextStyle(
        fontFamily: 'PretendardRegular',  // 폰트 설정
        fontSize: 14,
        color: Colors.black,
      )
    ),
  );
}