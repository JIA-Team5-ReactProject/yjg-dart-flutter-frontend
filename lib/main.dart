import 'package:flutter/material.dart';
import 'package:yjg/restaurant/menu_list.dart';
import 'package:yjg/restaurant/restaurant_main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,

     //최초 실행 페이지 설정
     initialRoute: '/restaurant_main',

     //라우트 설정
     routes: {
      '/restaurant_main' :(context) => RestaurantMain(),
      '/menu_list' :(context) => MenuList(),
     },

    );
  }
}
