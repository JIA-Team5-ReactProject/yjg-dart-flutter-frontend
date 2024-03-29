import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class PriceDataSource {
  static final Dio dio = Dio();
  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  PriceDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * 카테고리 목록 불러오기
  Future<Response> getCategoryListAPI() async {
    String url = '$apiURL/api/salon/category';

    try {
      final response = await dio.get((url));
      return response;
    } catch (e) {
      throw Exception('카테고리 목록을 불러오지 못했습니다.');
    }
  }

  // * 카테고리별 서비스 목록 불러오기
  Future<Map<String, dynamic>> getServiceListAPI(
      String selectedGender, int selectedCategoryId) async {
    String url = '$apiURL/api/salon/service';

    Map<String, String> queryParams = {
      'category_id': selectedCategoryId.toString(),
      'gender': selectedGender
    };

    try {
      final response = await dio.get(url, queryParameters: queryParams);
      return response.data;
    } catch (e) {
      throw Exception('서비스 목록을 불러오지 못했습니다.');
    }
  }
}
