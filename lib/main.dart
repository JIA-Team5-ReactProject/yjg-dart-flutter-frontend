import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:yjg/administration/presentaion/pages/admin_main.dart';
import 'package:yjg/administration/presentaion/pages/as_page.dart';
import 'package:yjg/administration/presentaion/pages/meeting_room.dart';
import 'package:yjg/administration/presentaion/pages/sleepover.dart';
import 'package:yjg/administration/presentaion/pages/sleepover_application.dart';
import 'package:yjg/auth/presentation/pages/international_registration_step1.dart';
import 'package:yjg/auth/presentation/pages/international_registration_step2.dart';
import 'package:yjg/auth/presentation/pages/login_google_domestic_students.dart';
import 'package:yjg/auth/presentation/pages/login_standard_foreign_international.dart';
import 'package:yjg/auth/presentation/pages/registration_details.dart';
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
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      //외박 신청 달력 언어 설정
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', ''), // Korean
      ],

      // title: 'YJG',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,

      //최초 실행 페이지 설정
      // initialRoute: '/dashboard_main',
      initialRoute: '/login_domestic',

      //라우트 설정
      routes: {
        // 최초 실행
        '/dashboard_main': (context) => DashboardMain(),

        // Auth 관련
        '/login_domestic': (context) => LoginGoogleDomesticStudents(),
        '/login_international_admin': (context) => LoginStandardInternational(),
        '/registration_detail': (context) => RegistrationDetails(),
        '/registration_international': (context) => InternationalRegisterationStep1(),
        '/registration_international_detail': (context) => InternationalRegisterationStep2(),


        // 식수 관련
        '/restaurant_main': (context) => RestaurantMain(),
        '/menu_list': (context) => MenuList(),
        '/weekend_meal': (context) => WeekendMeal(),
        '/meal_application': (context) => MealApplication(),
        '/meal_qr': (context) => MealQr(),

        // 미용실 관련
        '/salon_main': (context) => SalonMain(),
        '/salon_price_list': (context) => SalonPriceList(),
        '/salon_booking': (context) => SalonBooking(),

        // 버스 관련
        '/bus_main': (context) => BusMain(),
        '/bus_qr': (context) => BusQr(),
        '/bus_schedule': (context) => BusSchedule(),

        //행정 관련
        '/admin_main': (context) => AdminMain(),
        '/notice': (context) => Notice(),
        '/as_page': (context) => AsPage(),
        '/sleepover': (context) => Sleepover(),
        '/sleepover_application': (context) => SleepoverApplication(),
        '/meeting_room':(context) => MeetingRoom(),
      },
    );
  }
}
