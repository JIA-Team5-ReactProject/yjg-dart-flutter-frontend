import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class UserDataSource {
  // 유저 정보 호출
  static final Dio dio = Dio();

  UserDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // approve 변경
  Future<Response> patchApproveAPI() async {
    final data = {"approve": true};

    final url = '$apiURL/api/user/approve';

    try {
      final response = await dio.patch(url, data: data);

      debugPrint('patchApproveAPI 호출 성공');
      return response;
    } catch (e) {
      debugPrint('통신 결과: $e');
      throw Exception('approve 변경에 실패했습니다.');
    }
  }
}
