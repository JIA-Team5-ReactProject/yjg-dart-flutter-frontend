import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class FcmTokenDataSource {
  static final Dio dio = Dio();
  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  FcmTokenDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * FCM TOKEN 업데이트
  // 로그인 시 FCM 토큰을 업데이트, 자동 로그인 시에도 업데이트
  Future<Response> patchFcmTokenAPI() async {
    String url = '$apiURL/api/fcm-token';
    String fcmToken = storage.read(key: 'fcm_token').toString();

    final data = {
      'fcm_token': fcmToken,
    };

    try {
      final response = await dio.patch(url, data: data);
      debugPrint('FCM Token 업데이트 성공: $response');
      return response;
    } on DioException catch (e) {
      throw Exception('FCM Token 업데이트 오류 발생: $e');
    } catch (e) {
      throw Exception('FCM Token 업데이트에 실패하였습니다.');
    }
  }
}
