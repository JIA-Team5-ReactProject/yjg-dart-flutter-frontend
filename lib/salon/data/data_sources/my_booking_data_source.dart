import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class MyBookingDataSource {
  static final Dio dio = Dio();
  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  MyBookingDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  Future<Response> getReservationAPI() async {
    String url = '$apiURL/api/salon/reservation/user';

    try {
      final response = await dio.get(url);
      return response;
    } catch (e) {
      throw Exception('예약 목록을 불러오지 못했습니다.');
    }
  }
}
