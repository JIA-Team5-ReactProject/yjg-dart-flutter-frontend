import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:yjg/firebase_api.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart'; // MethodChannel을 위해 추가
import 'package:yjg/routes/app_routes.dart';
import 'package:yjg/shared/service/auth_service.dart';
import 'package:yjg/shared/service/device_info.dart';
import 'package:yjg/shared/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 네비게이터 키
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
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
    ProviderScope(
      child: MyApp(
        navigatorKey: navigatorKey,
        initialRoute: initialRoute!,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  static const platform = MethodChannel('com.example.yjg/navigation'); // 플랫폼 채널 추가

  MyApp({
    Key? key,
    required this.navigatorKey,
    required this.initialRoute,
  }) : super(key: key) {
    _navigateToInitialPage(); // 앱 시작 시 네이티브 코드로부터 페이지 정보를 받아 처리
  }

  final GlobalKey<NavigatorState> navigatorKey;
  final String initialRoute;

  Future<void> _navigateToInitialPage() async {
    try {
      final String page = await platform.invokeMethod('getInitialPage');
      debugPrint('Received page from native: $page');  // 로그를 추가하여 받은 페이지 정보를 확인
      if (page.isNotEmpty) {
        navigatorKey.currentState?.pushNamed(page);
      }
    } catch (e) {
      debugPrint('Error fetching initial page: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', ''), // Korean
      ],
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
