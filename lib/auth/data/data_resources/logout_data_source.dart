import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class LogoutDataSource {
  static final Dio dio = Dio();
  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  LogoutDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // 로그아웃
  Future<void> postLogoutAPI(WidgetRef ref) async {
    final String url = '$apiURL/api/logout';
    try {
      await dio.post(url);

      // 스토리지에 저장된 모든 정보를 삭제함
      await storage.deleteAll();

      debugPrint('로그아웃 완료');
    } catch (e) {
      debugPrint('로그아웃 실패: $e');
    }
  }
}
