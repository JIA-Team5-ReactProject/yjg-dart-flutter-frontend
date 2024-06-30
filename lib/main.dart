import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/firebase_api.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart'; // MethodChannel을 위해 추가
import 'package:yjg/routes/app_routes.dart';
import 'package:yjg/shared/service/auth_service.dart';
import 'package:yjg/shared/service/device_info.dart';
import 'package:yjg/shared/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 네비게이터 키
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // 다국어 설정
  await EasyLocalization.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications(); // 파이어베이스 FCM 초기화

  await dotenv.load(fileName: ".env");

  await getDeviceInfo();

  // 초기 라우터 설정
  final initialRoute = await AuthService().getInitialRoute();
  debugPrint('initialRoute: $initialRoute');

  // 스플래시 스크린 제거
  FlutterNativeSplash.remove();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('ko'), Locale('ja')],
      path: 'assets/langs', // JSON 파일 경로
      fallbackLocale: Locale('ja'),
      child: ProviderScope(
        child: MyApp(
          navigatorKey: navigatorKey,
          initialRoute: initialRoute!,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  static const platform =
      MethodChannel('com.example.yjg/navigation'); // 플랫폼 채널 추가
  final GlobalKey<NavigatorState> navigatorKey;
  final String initialRoute;

  MyApp({
    Key? key,
    required this.navigatorKey,
    required this.initialRoute,
  }) : super(key: key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToInitialPage(); // 앱 시작 후 네이티브 코드로부터 페이지 정보를 받아 처리
    });
  }

  Future<void> _navigateToInitialPage() async {
    try {
      final String? page =
          await platform.invokeMethod<String>('getInitialPage');
      final FlutterSecureStorage storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');
      final successAutoLogin = await storage.read(key: 'successAutoLogin');

      if (successAutoLogin == 'true' &&
          page != null &&
          page.isNotEmpty &&
          token != null) {
        debugPrint('안드로이드로 부터 받은 페이지: $page');
        navigatorKey.currentState?.pushReplacementNamed(page);
      } else {
        debugPrint('토큰 x 안드로이드로 부터 받은 페이지 /login_student');
        navigatorKey.currentState?.pushReplacementNamed('/login_student');
      }
    } catch (e) {
      debugPrint('에러: $e');
      navigatorKey.currentState?.pushReplacementNamed('/login_student');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        EasyLocalization.of(context)!.delegate,
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
