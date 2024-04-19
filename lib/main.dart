import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:yjg/routes/app_routes.dart';
import 'package:yjg/shared/service/auth_service.dart';
import 'package:yjg/shared/service/device_info.dart';
import 'package:yjg/shared/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 네비게이터 키
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 빌드가 안 될 경우 주석 해제 후 실행해 볼 것
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

  await dotenv.load(fileName: ".env");

  await getDeviceInfo();

  // 초기 라우터 설정
  final initialRoute = await AuthService().getInitialRoute();
  debugPrint('initialRoute: $initialRoute');

  // 스플래시 스크린 제거
  FlutterNativeSplash.remove();

  runApp(
    ProviderScope(
      child: MyApp(
        navigatorKey: navigatorKey,
        initialRoute: initialRoute!,
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
      routes: AppRoutes.routes,
    );
  }
}
