import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:yjg/screens/admin/admin_main.dart';
import 'package:yjg/screens/restaurant/meal_application.dart';
import 'package:yjg/screens/restaurant/meal_qr.dart';
import 'package:yjg/screens/restaurant/menu_list.dart';
import 'package:yjg/screens/restaurant/restaurant_main.dart';
import 'package:yjg/screens/dashboard/dashboard_main.dart';
import 'package:yjg/screens/restaurant/weekend_meal.dart';
import 'package:yjg/screens/salon/salon_main.dart';
import 'package:yjg/screens/salon/salon_price_list.dart';
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
        // 최초 실행
        '/dashboard_main': (context) => DashboardMain(),

        // 식수 관련
        '/restaurant_main': (context) => RestaurantMain(),
        '/menu_list': (context) => MenuList(),
        '/weekend_meal' :(context) => WeekendMeal(),
        '/meal_application' :(context) => MealApplication(),
        '/meal_qr' :(context) => MealQr(),

        // 미용실 관련
        '/salon_main': (context) => SalonMain(),
        '/price_list': (context) => SalonPriceList(),

        //행정 관련
        '/admin_main':(context) => AdminMain(),
      },
    );
  }
}
