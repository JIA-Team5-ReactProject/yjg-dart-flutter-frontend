import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:yjg/screens/restaurant/menu_list.dart';
import 'package:yjg/screens/restaurant/restaurant_main.dart';
import 'package:yjg/screens/dashboard/dashboard_main.dart';
import 'package:yjg/screens/restaurant/weekend_meal.dart';
import 'package:yjg/theme/theme.dart';

void main() async { 

  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'YJG',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,

      //최초 실행 페이지 설정
      initialRoute: '/dashboard_main',

      //라우트 설정
      routes: {
        '/dashboard_main': (context) => DashboardMain(),
        '/restaurant_main': (context) => RestaurantMain(),
        '/menu_list': (context) => MenuList(),
        '/weekend_meal' :(context) => WeekendMeal()
      },
    );
  }
}
