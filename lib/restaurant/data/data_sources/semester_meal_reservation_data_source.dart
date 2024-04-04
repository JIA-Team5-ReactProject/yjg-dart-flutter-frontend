import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class SemesterMealReservationDataSource {
  static final storage = FlutterSecureStorage();
  static final Dio dio = Dio();

  SemesterMealReservationDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * 사용자 정보를 가져오는 API 함수
  Future<Response> fetchUserInfo() async {
    String url = '$apiURL/api/restaurant/semester/show/user';

    try {
      final response = await dio.get(url);

      return response;
    } catch (e) {
      throw Exception('유저 정보를 불러오지 못했습니다.');
    }
  }

  // * 식수 유형의 정보를 가져오는 API 함수
  Future<Response> fetchMealTypes() async {
    String url = '$apiURL/api/restaurant/semester/meal-type/get';
    try {
      final response = await dio.get(url);

      return response;
    } catch (e) {
      throw Exception('식사 유형을 불러오지 못했습니다.');
    }
  }

  // * 식수 신청을 하는 API 함수
  Future<void> submitMealApplication(String mealType) async {
    final data = {
      'meal_type': mealType,
    };

    final url = '$apiURL/api/restaurant/semester';

    try {
      await dio.post(url, data: data);
    } catch (e) {
      throw Exception('식수 신청을 하지 못했습니다.');
    }
  }

  // * 식수 신청 상태를 가져오는 API 함수
  Future<Response> fetchApplicationStatus() async {
    try {
      final url = '$apiURL/api/restaurant/semester/show/user/after';
      final response = await dio.get(url);

      return response;
    } catch (e) {
      throw Exception('식수 신청 상태를 불러오지 못했습니다.');
    }
  }

  // * 식수 신청을 취소하는 API 함수
  Future<void> cancelMealApplication(applicationId) async {
    final url = '$apiURL/api/restaurant/semester/delete/$applicationId';

    try {
      await dio.delete(url);
    } catch (e) {
      throw Exception('식수 신청을 취소하지 못했습니다.');
    }
  }
}
