import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class RegisterDataSource {
  static final Dio dio = Dio();

  RegisterDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  Future<Response> postRegisterAPI(WidgetRef ref) async {
    // state 값 가져오기
    final registerState = ref.read(userProvider.notifier);
    String url = '$apiURL/api/user';

    final data = {
      'email': registerState.email,
      'password': registerState.password,
      'name': registerState.name,
      'phone_number': registerState.phoneNumber,
      'student_id': registerState.studentId,
    };

    try {
      final response = await dio.post(url,
          data: data, options: Options(extra: {"noAuth": true}));

      debugPrint('결과: ${response.data}');
      return response;
    } catch (e) {
      debugPrint('통신 결과: $e');
      throw Exception('회원가입에 실패했습니다.');
    }
  }

  // 이메일 중복 검사 API 호출
  Future<bool> checkEmailDuplicate(String email) async {
    try {
      final url = '$apiURL/api/verify-email/$email';
      final response =
          await dio.get(url, options: Options(extra: {"noAuth": true}));

      if (response.statusCode == 200) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
        return true;
    }
  }
}
