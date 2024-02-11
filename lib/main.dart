import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:yjg/administration/presentaion/pages/admin_main.dart';
import 'package:yjg/bus/presentaion/pages/bus_main.dart';
import 'package:yjg/bus/presentaion/pages/bus_qr.dart';
import 'package:yjg/bus/presentaion/pages/bus_schedule.dart';
import 'package:yjg/administration/presentaion/pages/notice.dart';
import 'package:yjg/restaurant/presentaion/pages/meal_application.dart';
import 'package:yjg/restaurant/presentaion/pages/meal_qr.dart';
import 'package:yjg/restaurant/presentaion/pages/menu_list.dart';
import 'package:yjg/restaurant/presentaion/pages/restaurant_main.dart';
import 'package:yjg/dashboard/presentaion/pages/dashboard_main.dart';
import 'package:yjg/restaurant/presentaion/pages/weekend_meal.dart';
import 'package:yjg/salon/presentaion/pages/salon_booking.dart';
import 'package:yjg/salon/presentaion/pages/salon_main.dart';
import 'package:yjg/salon/presentaion/pages/salon_price_list.dart';
import 'package:yjg/shared/theme/theme.dart';

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
        '/salon_price_list': (context) => SalonPriceList(),
        '/salon_booking' : (context) => SalonBooking(),

        // 버스 관련
        '/bus_main': (context) => BusMain(),
        '/bus_qr':(context) => BusQr(),
        '/bus_schedule':(context) => BusSchedule(),

        //행정 관련
        '/admin_main':(context) => AdminMain(),
        '/notice' :(context) => Notice(),
      },
    );
  }
}
