import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:yjg/auth/data/data_resources/login_data_source.dart';
import 'package:yjg/main.dart';

final storage = FlutterSecureStorage();

void tokenDecoder(String? token, String autoLoginStr) async {
  bool hasExpired = JwtDecoder.isExpired(token!);

  debugPrint('토큰 만료 여부: $hasExpired');

  // 자동로그인이 true이고, 토큰이 만료되었을 경우 토큰 교체
  if (autoLoginStr == 'true' && hasExpired) {
    LoginDataSource().getRefreshTokenAPI();
    debugPrint('토큰 교체 완료');
  }

  // 자동로그인이 false이고, 토큰이 만료되었을 경우 로그아웃
  if (autoLoginStr == 'false' && hasExpired) {
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'refresh_token');
    navigatorKey.currentState!.pushNamedAndRemoveUntil('/login_student', (route) => false);
    debugPrint('토큰 삭제 완료');
  }

  // 토큰이 만료되지 않았을 경우 토큰 payload 출력
  else {
    final payload = JwtDecoder.decode(token);
    debugPrint('토큰 payload: $payload');
  }
}
