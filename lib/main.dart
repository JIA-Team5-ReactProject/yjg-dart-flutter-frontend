import 'package:capstone/siksu/menu_list.dart';
import 'package:capstone/siksu/siksu_main.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,

     //최초 실행 페이지 설정
     initialRoute: '/siksu_main',

     //라우트 설정
     routes: {
      '/siksu_main' :(context) => SiksuMain(),
      '/menu_list' :(context) => MenuList(),
     },

    );
  }
}
