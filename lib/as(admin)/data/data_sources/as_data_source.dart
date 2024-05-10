import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class AsDataSource {
  static final Dio dio = Dio();
  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  AsDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * as 데이터
  Future<Response> getAsDataAPI(int status, int page) async {
    String url = '$apiURL/api/after-service';

    debugPrint('status: $status, page: $page');

    Map<String, String> queryParams = {
      'status': status.toString(),
      'page': page.toString(),
    };

    try {
      final response = await dio.get(
        url,
        queryParameters: queryParams,
      );

      debugPrint('response: $response');
      return response;
    } catch (e) {
      throw Exception('AS 데이터 가져오기에 실패했습니다.');
    }
  }
}
