import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class AdminServiceDataSource {
  static final Dio dio = Dio();
  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  AdminServiceDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

// * 서비스 생성
  Future<Response> postServiceAPI(int categoryId, String? serviceName,
      String? gender, String? price) async {
    String url = '$apiURL/api/salon/service';
    final data = {
      'category_id': categoryId,
      'service': serviceName,
      "gender": gender,
      "price": price
    };

    try {
      final response = await dio.post(url, data: data);
      return response;
    } catch (e) {
      throw Exception('서비스 생성에 실패했습니다.');
    }
  }

  // * 서비스 수정
  Future<Response> patchServiceAPI(
      int serviceId, String? serviceName, String? gender, String? price) async {
    String url = '$apiURL/api/salon/service/$serviceId';

    final data = {'service': serviceName, "gender": gender, "price": price};

    try {
      final response = await dio.patch(url, data: data);

      return response;
    } catch (e) {
      throw Exception('서비스 수정에 실패했습니다.');
    }
  }

  // * 서비스 삭제
  Future<Response> deleteServiceListAPI(int serviceId) async {
    String url = '$apiURL/api/salon/service/$serviceId';

    try {
      final response = await dio.delete(url);
      return response;
    } catch (e) {
      throw Exception('서비스 삭제에 실패했습니다.');
    }
  }
}
