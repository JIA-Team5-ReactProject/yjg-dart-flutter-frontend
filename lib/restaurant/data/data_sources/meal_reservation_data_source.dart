import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class MealReservationDataSource {
  static final storage = FlutterSecureStorage();
  static final Dio dio = Dio();

  MealReservationDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * 주말 신청 인원 불러오는 GET API 함수
  Future<Response> fetchSatApplicationCounts(String weekend) async {
    String url = '$apiURL/api/restaurant/weekend/show/sumApp';

    Map<String, String> queryParams = {'date': weekend};

    try {
      final response = await dio.get(
        url,
        queryParameters: queryParams,
      );

      return response;
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('주말 신청 인원을 불러오지 못했습니다.');
    }
  }

  // * 주말 식수 신청 가능 기간 받아오는 GET API
  Future<bool> fetchWeekendApplyState() async {
    String url = '$apiURL/api/restaurant/apply/state/check/weekend';
    try {
      final response = await dio.get(url);
      final data = response.data;
      // 'state'의 내부 'state' 값에 따라 true 또는 false 반환
      if (data['manual'] == 1) {
        return true; // 'state'의 'state' 값이 1이면 true 반환
      } else {
        return false; // 그렇지 않으면 false 반환
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('주말 신청 상태를 불러오지 못했습니다.');
    }
  }

  // * 학기 식수 신청 가능 기간 받아오는 GET API

  Future<bool> fetchSemesterApplyState() async {
    try {
      String url = '$apiURL/api/restaurant/apply/state/check/semester';
      final response = await dio.get(url);
      final data = response.data;

      // 'state'의 내부 'state' 값에 따라 true 또는 false 반환
      if (data['manual'] == 1) {
        return true; // 'state'의 'state' 값이 1이면 true 반환
      } else {
        return false; // 그렇지 않으면 false 반환
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('학기 신청 상태를 불러오지 못했습니다.');
    }
  }

  // * 계좌 번호 데이터를 불러오는 GET API 함수
  Future<Response> fetchAccountData() async {
    final url = '$apiURL/api/restaurant/account/show';

    try {
      final response = await dio.get(url);

      return response;
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('계좌 번호를 불러오지 못했습니다.');
    }
  }
}
