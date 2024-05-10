import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class AdminCategoryDataSource {
  static final Dio dio = Dio();
  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  AdminCategoryDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

// * 카테고리 생성
  Future<Response> postCategoryAPI(String categoryName) async {
    String url = '$apiURL/api/salon/category';
    final data = {'category': categoryName};

    try {
      final response = await dio.post(url, data: data);
      return response;
    } catch (e) {
      debugPrint('통신 결과: $e');
      throw Exception('카테고리 생성에 실패했습니다.');
    }
  }

  // * 카테고리 수정
  Future<Response> patchCategoryAPI(
      int categoryId, String? categoryNaame) async {
    String url = '$apiURL/api/salon/category';
    final data = {
      'category_id': categoryId,
      'category': categoryNaame,
    };

    try {
      final response = await dio.patch(url, data: data);
      return response;
    } catch (e) {
      debugPrint('통신 결과: $e');
      throw Exception('카테고리 수정에 실패했습니다.');
    }
  }

  // * 카테고리 삭제
  Future<Response> deleteCategoryAPI(int categoryId) async {
    String url = '$apiURL/api/salon/category/$categoryId';

    try {
      final response = await dio.delete(url);
      return response;
    } catch (e) {
      debugPrint('통신 결과: $e');
      throw Exception('카테고리 삭제에 실패했습니다.');
    }
  }
}
