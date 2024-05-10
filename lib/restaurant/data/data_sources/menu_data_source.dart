import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class MenuDataSource {
  static final storage = FlutterSecureStorage();
  static final Dio dio = Dio();

  MenuDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * 오늘 식단표 불러오는 GET API 함수
  Future<Response> fetchMenus() async {
    final formattedDate =
        DateTime.now().toIso8601String().substring(0, 10); // 시간 제외하고 날짜만 가져옴

    String url = '$apiURL/api/restaurant/menu/get/d?date=$formattedDate';

    try {
      final response = await dio.get(url);

      return response;
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('식단표를 불러오지 못했습니다.');
    }
  }
  
  // * 해당 날짜의 식단표를 불러오는 API 함수
  Future<Response> fetchSelectedDayMenus(DateTime selectedDay) async {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
    final String url = '$apiURL/api/restaurant/menu/get/d?date=$formattedDate';

    try {
      final response = await dio.get(url);

      return response;
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('식단표를 불러오지 못했습니다.');
    }
  }
}
