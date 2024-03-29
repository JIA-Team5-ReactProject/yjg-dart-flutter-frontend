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

    debugPrint('userType: $userType');

    if (autoLoginStr != 'true' || (token == null && refreshToken == null)) {
      return '/login_student';
    }

    if (token == null || JwtDecoder.isExpired(token)) {
      debugPrint('token is expired');
      await LoginDataSource().getRefreshTokenAPI();
      final newToken = await storage.read(key: 'auth_token');
      debugPrint(
          'newToken 유효성 여부: ${JwtDecoder.isExpired(newToken ?? 'null')}');
      if (newToken != null && !JwtDecoder.isExpired(newToken)) {
        final initRoute = AppRoutes.getInitialRouteBasedOnUserType(userType);
        debugPrint('initRoute: $initRoute');
        return initRoute;
      }
      return '/login_student';
    }

    return AppRoutes.getInitialRouteBasedOnUserType(userType);
  }
}
