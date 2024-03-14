import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:yjg/administration/presentaion/pages/admin_main.dart';
import 'package:yjg/administration/presentaion/pages/as_application.dart';
import 'package:yjg/administration/presentaion/pages/as_page.dart';
import 'package:yjg/administration/presentaion/pages/meeting_room.dart';
import 'package:yjg/administration/presentaion/pages/sleepover.dart';
import 'package:yjg/administration/presentaion/pages/sleepover_application.dart';
import 'package:yjg/as(admin)/presentation/pages/as_detail.dart';
import 'package:yjg/as(admin)/presentation/pages/as_main.dart';
import 'package:yjg/auth/presentation/pages/international_registration.dart';
import 'package:yjg/auth/presentation/pages/student_login.dart';
import 'package:yjg/auth/presentation/pages/admin_login.dart';
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
import 'package:yjg/salon/presentaion/pages/admin/admin_salon_booking.dart';
import 'package:yjg/salon/presentaion/pages/admin/admin_salon_main.dart';
import 'package:yjg/salon/presentaion/pages/salon_booking_step_one.dart';
import 'package:yjg/salon/presentaion/pages/salon_booking_step_two.dart';
import 'package:yjg/salon/presentaion/pages/salon_main.dart';
import 'package:yjg/salon/presentaion/pages/salon_my_book.dart';
import 'package:yjg/salon/presentaion/pages/salon_price_list.dart';
import 'package:yjg/shared/service/device_info.dart';
import 'package:yjg/shared/service/load_set_student_name.dart';
import 'package:yjg/shared/service/token_decoder.dart';
import 'package:yjg/shared/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 네비게이터 키
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = FlutterSecureStorage();
  await dotenv.load(fileName: ".env");

  await getDeviceInfo();

  // String initialRoute = '/salon_main'; // ! 로그인 안 할 경우 원하는 라우터를 입력해주세요.

  // ! 로그인 할 경우 FlutterNativePlash.remove() 전에 작성된 모든 코드의 주석을 해제해주세요.
  String initialRoute = '/login_student';

  final token = await storage.read(key: 'auth_token');
  final autoLoginStr = await storage.read(key: 'auto_login');
  final refreshToken = await storage.read(key: 'refresh_token');
  bool hasExpired = JwtDecoder.isExpired(token!);
  debugPrint('token: $token');
  debugPrint('refreshToken: $refreshToken');
  
  tokenDecoder(token, autoLoginStr!);
  String? userType = await storage.read(key: 'userType');

  // 자동로그인이 true이고, 토큰이 만료되지 않았을 경우
  if (autoLoginStr == 'true' && hasExpired == false) {
    switch (userType) {
      case 'student':
        initialRoute = '/dashboard_main'; // 학생 대시보드로 이동
        break;
      case 'admin':
        initialRoute = '/as_admin'; // AS 관리자 페이지로 이동
        break;
      case 'salon':
        initialRoute = '/admin_salon_main'; // 미용실 관리자 페이지로 이동
        break;
      default:
        // 사용자 유형이 지정되지 않았거나 잘못된 경우, 로그인 페이지로 이동
        initialRoute = '/login_student';
        break;
    }
  }

  // 스플래시 스크린 제거
  FlutterNativeSplash.remove();

  runApp(
    ProviderScope(
      child: MyApp(
        navigatorKey: navigatorKey,
        initialRoute: initialRoute,
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String initialRoute;

  const MyApp(
      {super.key, required this.navigatorKey, required this.initialRoute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    loadAndSetStudentName(ref); // 로그인 이름 설정

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

      navigatorKey: navigatorKey,
      initialRoute: initialRoute,

      //라우트 설정
      routes: {
        // 최초 실행
        '/dashboard_main': (context) => DashboardMain(),

        // Auth 관련
        '/login_student': (context) => StudentLogin(),
        '/login_admin': (context) => AdminLogin(),
        '/registration_detail': (context) => RegistrationDetails(),
        '/registration_international': (context) =>
            InternationalRegisteration(),

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
        '/admin_salon_price_list': (context) => SalonPriceList(),
        '/admin_salon_booking': (context) => AdminSalonBooking(),

        // 버스 관련
        '/bus_main': (context) => BusMain(),
        '/bus_qr': (context) => BusQr(),
        '/bus_schedule': (context) => BusSchedule(),

        //행정 관련
        '/admin_main': (context) => AdminMain(),
        '/notice': (context) => Notice(),
        '/as_page': (context) => AsPage(),
        '/as_application': (context) => AsApplication(),
        '/sleepover': (context) => Sleepover(),
        '/sleepover_application': (context) => SleepoverApplication(),
        '/meeting_room': (context) => MeetingRoom(),

        // AS 관련(관리자)
        '/as_admin': (context) => AsMain(),
        '/as_detail': (context) => AsDetail(),
      },
    );
  }
}
