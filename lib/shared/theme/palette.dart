import 'package:flutter/material.dart';

// 앱의 전체적인 색상을 관리하는 클래스
class Palette {

  // 기본적인 배경 색상
  static const Color backgroundColor = Colors.white;

  // 메인 색상
  static const Color mainColor = Color.fromRGBO(0, 127, 160, 1);

  // 기본 텍스트 색상
  static const Color textColor = Colors.black;

  // 앱바 타이틀 색상
  static const Color appBarTitleColor = Colors.white;

  // state 아이콘, 텍스트 색상 지정(ex: 방문 예정, 방문 완료 등)
  static const Color stateColor1 = Color.fromRGBO(0, 127, 160, 1);    // 접수 완료
  static const Color stateColor2 = Color.fromRGBO(255, 111, 68, 1);     // 방문 예정
  static const Color stateColor3 = Color.fromRGBO(161, 0, 0, 1);      // 방문 완료
  static const Color stateColor4 = Color.fromRGBO(149, 149, 149, 1);  // 요청 거절

  // alert 창 발생시 배경 불투명한 회색
  static const Color alertBackgroundColor = Color.fromRGBO(0, 0, 0, 0.6);
}