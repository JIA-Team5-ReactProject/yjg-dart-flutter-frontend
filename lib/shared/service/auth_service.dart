import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:yjg/auth/data/data_resources/login_data_source.dart';
import 'package:yjg/routes/app_routes.dart';

class AuthService {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<String?> getInitialRoute() async {
    final token = await storage.read(key: 'auth_token');
    final autoLoginStr = await storage.read(key: 'auto_login') ?? 'false';
    final refreshToken = await storage.read(key: 'refresh_token');
    final userType = await storage.read(key: 'userType');

    debugPrint('액세스 토큰: $token');
    debugPrint('리프레시 토큰: $refreshToken');
    debugPrint('자동 로그인: $autoLoginStr');

    if (autoLoginStr == 'false' || (token == null && refreshToken == null)) {
      debugPrint('자동로그인 미설정, 유저 정보 삭제');
      await storage.deleteAll();
      return '/login_student';
    }

    if (autoLoginStr == 'true' &&
        (token != null && JwtDecoder.isExpired(token))) {
      // 리프레시 토큰으로 액세스 토큰 갱신
      await LoginDataSource().getRefreshTokenAPI();

      // 갱신된 액세스 토큰으로 초기 라우터 설정
      final newToken = await storage.read(key: 'auth_token');
      // 갱신 토큰이 null이 아니고, 만료되지 않았다면 초기 라우터 설정
      if (newToken != null && !JwtDecoder.isExpired(newToken)) {
        final initRoute = AppRoutes.getInitialRouteBasedOnUserType(userType);
        return initRoute;
      }
    }

    return AppRoutes.getInitialRouteBasedOnUserType(userType);
  }
}
