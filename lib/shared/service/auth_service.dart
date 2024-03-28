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

    debugPrint('autoLoginStr: $autoLoginStr');
    debugPrint('userType: $userType');

    if (autoLoginStr != 'true' || (token == null && refreshToken == null)) {
      return '/login_student';
    }

    if (token == null || JwtDecoder.isExpired(token)) {
      debugPrint('token is expired');
      await LoginDataSource().getRefreshTokenAPI();
      final newToken = await storage.read(key: 'auth_token');
      return newToken != null && !JwtDecoder.isExpired(newToken)
          ? AppRoutes.getInitialRouteBasedOnUserType(userType)
          : '/login_student';
    }

    return AppRoutes.getInitialRouteBasedOnUserType(userType);
  }
}

