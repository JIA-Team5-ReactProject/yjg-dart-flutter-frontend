import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class WeekendMealReservationDataSource {
  static final storage = FlutterSecureStorage();
  static final Dio dio = Dio();

  WeekendMealReservationDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * 식수 유형 POST로 보내는 API 함수
  Future<void> postMealTypeAPI(mealType, refund, sat, sun) async {
    final url = '$apiURL/api/restaurant/weekend';

    final data = {
      'meal_type': mealType,
      'refund': refund,
      'sat': sat,
      'sun': sun,
    };

    try {
      final response = await dio.post(url, data: data);
      debugPrint('식수 유형 POST 성공: $response');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('식수 유형을 보내지 못했습니다.');
    }
  }

  // * 식사 유형 데이터(버튼) 불러오는 GET API 함수
  Future<Response> fetchMealTypes() async {
    String url = '$apiURL/api/restaurant/weekend/meal-type/get';

    try {
      final response = await dio.get(url);
      return response;
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('식사 유형을 불러오지 못했습니다.');
    }
  }

  // * 신청자 데이터 불러오는 GET API 함수
  Future<Response> fetchUserData() async {
    final url = '$apiURL/api/restaurant/weekend/show/user/table';

    try {
      final response = await dio.get(url);
      return response;
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('신청자 데이터를 불러오지 못했습니다.');
    }
  }

  // * 신청 취소하는 DELETE API 함수

  Future<void> deleteApplication(int id) async {
    final url = '$apiURL/api/restaurant/weekend/delete/$id';

    try {
      final response = await dio.delete(url);

      debugPrint('취소 성공: $response');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('신청 취소를 실패했습니다.');
    }
  }
}
