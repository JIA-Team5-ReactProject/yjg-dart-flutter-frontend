import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class BusDataSource {
  static final Dio dio = Dio();
  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  BusDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * 버스 데이터
  Future<Response> getBusDataAPI(
      int weekend, int semester, String route) async {
    String url = '$apiURL/api/bus/round/appSchedule';

    debugPrint('weekend: $weekend, semester: $semester, route: $route');

    Map<String, String> queryParams = {
      'weekend': weekend.toString(),
      'semester': semester.toString(),
      'bus_route_direction': route,
    };

    try {
      final response = await dio.get(url, queryParameters: queryParams);
      return response;
    } catch (e) {
      throw Exception('버스 데이터를 불러오지 못했습니다.');
    }
  }
}
