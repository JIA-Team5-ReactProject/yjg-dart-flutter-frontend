import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class UrgentDataSource {
  static final Dio dio = Dio(); // Dio 인스턴스 생성
  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  UrgentDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

// * 최근 공지사항
  Future<Response> getUrgentApi() async {
    String url = '$apiURL/api/notice/recent/urgent';

    try {
      final response = await dio.get(url);

      return response;
    } catch (e) {
      throw Exception('최근 공지 데이터 가져오기에 실패하였습니다.');
    }
  }
}
