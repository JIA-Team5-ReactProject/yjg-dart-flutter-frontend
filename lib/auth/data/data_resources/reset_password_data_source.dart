import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/auth/presentation/viewmodels/verify_code_viewmodel.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class ResetPasswordDataSource {
  static final Dio dio = Dio();
  static final storage = FlutterSecureStorage();

  ResetPasswordDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * 이메일 전송
  Future<Response> postResetPasswordAPI(WidgetRef ref) async {
    final loginState = ref.read(userProvider.notifier);
    String url = '$apiURL/api/reset-password';
    final data = {
      'email': loginState.email,
      'name': loginState.name,
    };

    try {
      final response = await dio.post(
        url,
        data: data,
        options: Options(extra: {"noAuth": true}),
      );

      debugPrint('결과: ${response.data} ${response.statusCode}');
      return response;
    } catch (e) {
      debugPrint('통신 결과: $e');
      throw Exception('비밀번호 재설정에 실패했습니다.');
    }
  }

  // * 인증번호 검증
  Future<Response> postResetPasswordMailVerifyAPI(WidgetRef ref) async {
    final verifyCode = ref.watch(verifyCodeProvider.notifier).state;
    final loginState = ref.watch(userProvider.notifier);

    final url = '$apiURL/api/reset-password/verify';

    Map<String, String> queryParams = {
      'code': verifyCode.toString(),
      'email': loginState.email,
    };

    try {
      final response = await dio.get(
        url,
        queryParameters: queryParams,
        options: Options(extra: {"noAuth": true}),
      );

      final token = response.data['email_token'];
      await storage.write(key: 'auth_token', value: token);

      return response;
    } catch (e) {
      debugPrint('통신 결과: $e');
      throw Exception('인증번호 검증에 실패했습니다.');
    }
  }

  // * 비밀번호 재설정
  Future<Response> patchNewPasswordAPI(WidgetRef ref) async {
    final loginState = ref.read(userProvider.notifier);
    String url = '$apiURL/api/reset-password';
    final data = {
      'password': loginState.newPassword,
    };

    try {
      final response = await dio.patch(
        url,
        data: data,
      );
      debugPrint('결과: ${response.data} ${response.statusCode}');
      return response;
    } catch (e) {
      debugPrint('통신 결과: $e');
      throw Exception('비밀번호 재설정에 실패했습니다.');
    }
  }
}
