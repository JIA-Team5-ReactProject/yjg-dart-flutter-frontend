import 'package:flutter/material.dart';
import 'package:yjg/administration/presentaion/pages/notice_detail_page.dart';
import 'package:yjg/auth/presentation/pages/new_password_update.dart';
import 'package:yjg/auth/presentation/pages/student_login.dart';
import 'package:yjg/dashboard/presentaion/pages/dashboard_main.dart';
import 'package:yjg/administration/presentaion/pages/admin_main.dart';
import 'package:yjg/administration/presentaion/pages/as_application.dart';
import 'package:yjg/administration/presentaion/pages/as_page.dart';
import 'package:yjg/administration/presentaion/pages/meeting_room_app.dart';
import 'package:yjg/administration/presentaion/pages/meeting_room_main.dart';
import 'package:yjg/administration/presentaion/pages/sleepover.dart';
import 'package:yjg/administration/presentaion/pages/sleepover_application.dart';
import 'package:yjg/as(admin)/presentation/pages/as_detail.dart';
import 'package:yjg/as(admin)/presentation/pages/admin_as_main.dart';
import 'package:yjg/auth/presentation/pages/international_registration.dart';
import 'package:yjg/auth/presentation/pages/mail_verification_code.dart';
import 'package:yjg/auth/presentation/pages/reset_password.dart';
import 'package:yjg/auth/presentation/pages/admin_login.dart';
import 'package:yjg/auth/presentation/pages/registration_details.dart';
import 'package:yjg/auth/presentation/pages/update_user.dart';
import 'package:yjg/bus/presentaion/pages/bus_main.dart';
import 'package:yjg/bus/presentaion/pages/bus_qr.dart';
import 'package:yjg/bus/presentaion/pages/bus_schedule.dart';
import 'package:yjg/administration/presentaion/pages/notice.dart';
import 'package:yjg/restaurant/presentaion/pages/meal_application.dart';
import 'package:yjg/restaurant/presentaion/pages/meal_qr.dart';
import 'package:yjg/restaurant/presentaion/pages/menu_list.dart';
import 'package:yjg/restaurant/presentaion/pages/restaurant_main.dart';
import 'package:yjg/restaurant/presentaion/pages/weekend_meal.dart';
import 'package:yjg/salon/presentaion/pages/admin/admin_salon_booking.dart';
import 'package:yjg/salon/presentaion/pages/admin/admin_salon_main.dart';
import 'package:yjg/salon/presentaion/pages/admin/admin_salon_price_list.dart';
import 'package:yjg/salon/presentaion/pages/salon_booking_step_one.dart';
import 'package:yjg/salon/presentaion/pages/salon_booking_step_two.dart';
import 'package:yjg/salon/presentaion/pages/salon_main.dart';
import 'package:yjg/salon/presentaion/pages/salon_my_book.dart';
import 'package:yjg/salon/presentaion/pages/salon_price_list.dart';
import 'package:yjg/setting/setting_page.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    // 최초 실행
    '/dashboard_main': (context) => DashboardMain(),

    // Auth 관련
    '/login_student': (context) => StudentLogin(),
    '/login_admin': (context) => AdminLogin(),
    '/registration_detail': (context) => RegistrationDetails(),
    '/registration_international': (context) => InternationalRegisteration(),
    '/update_user': (context) => UpdateUser(),
    '/reset_password': (context) => ResetPassword(),
    '/mail_verification_code': (context) => MailVerficationCode(),
    '/new_password': (context) => newPasswordUpdate(),

    // 식수 관련
    '/restaurant_main': (context) => RestaurantMain(),
    '/menu_list': (context) => MenuList(),
    '/weekend_meal': (context) => WeekendMeal(),
    '/meal_application': (context) => MealApplication(),
    '/meal_qr': (context) => MealQr(),

    // 미용실 관련
    '/salon_main': (context) => SalonMain(),
    '/salon_price_list': (context) => SalonPriceList(),
    '/salon_booking_step_one': (context) => SalonBookingStepOne(),
    '/salon_booking_step_two': (context) => SalonBookingStepTwo(),
    '/salon_my_book': (context) => SalonMyBook(),

    // 미용실 관련(관리자)
    '/admin_salon_main': (context) => AdminSalonMain(),
    '/admin_salon_price_list': (context) => AdminSalonPricelist(),
    '/admin_salon_booking': (context) => AdminSalonBooking(),

    // 버스 관련
    '/bus_main': (context) => BusMain(),
    '/bus_qr': (context) => BusQr(),
    '/bus_schedule': (context) => BusSchedule(),

    //행정 관련
    '/admin_main': (context) => AdminMain(),
    '/notice': (context) => Notice(),
    '/notice_detail': (context) {
      final noticeId = ModalRoute.of(context)!.settings.arguments as int;
      return NoticeDetailPage(noticeId: noticeId);
    },
    '/as_page': (context) => AsPage(),
    '/as_application': (context) => AsApplication(),
    '/sleepover': (context) => Sleepover(),
    '/sleepover_application': (context) => SleepoverApplication(),
    '/meeting_room_app': (context) => MeetingRoomApp(),
    '/meeting_room_main': (context) => MeetingRoomMain(),

    // AS 관련(관리자)
    '/as_admin': (context) => AsMain(),
    '/as_detail': (context) => AsDetail(),

    // 설정
    '/setting': (context) => SettingPage(),
  };

  static String getInitialRouteBasedOnUserType(String? userType) {
    switch (userType) {
      case 'student':
        return '/dashboard_main';
      case 'admin':
        return '/as_admin';
      case 'salon':
        return '/admin_salon_main';
      default:
        return '/login_student';
    }
  }
}
