import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:yjg/auth/data/data_resources/login_data_source.dart';

void tokenDecoder(String? token) {
  bool hasExpired = JwtDecoder.isExpired(token!);

  debugPrint('토큰 만료 여부: $hasExpired');
  if (hasExpired) {
    LoginDataSource().getRefreshTokenAPI();
    debugPrint('토큰 교체 완료');
  } else {
    final payload = JwtDecoder.decode(token);
    debugPrint('토큰 payload: $payload');
  }
}

