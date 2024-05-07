import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/auth/data/data_resources/google_login_data_source.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class LogoutDataSource {
  static final Dio dio = Dio();
  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  LogoutDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * 로그아웃
  Future<void> postLogoutAPI(WidgetRef ref) async {
    final String url = '$apiURL/api/logout';
    try {
      await dio.post(url);

      // 만약 구글 로그인을 통해 로그인했을 경우 구글 로그아웃
      final loginType = await storage.read(key: 'login_type');
      if (loginType == 'google') {
        GoogleLoginDataSource().logoutWithGoogle();
      }

      // 스토리지에 저장된 모든 정보를 삭제함
      await storage.deleteAll();
      await FirebaseMessaging.instance.deleteToken(); // fcm 토큰 삭제

      debugPrint('로그아웃 완료');
    } catch (e) {
      debugPrint('로그아웃 실패: $e');
    }
  }
}
