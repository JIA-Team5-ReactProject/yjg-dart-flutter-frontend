import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class QrImgDataSource {
  static final Dio dio = Dio();
  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  QrImgDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * 버스, 식수 QR
  Future<Response> getImgQRDataAPI() async {
    String url = '$apiURL/api/user/qr';

    try {
      final response = await dio.post(
        url,
      );
      return response;
    } catch (e) {
      throw Exception('QR 데이터를 불러오지 못했습니다.');
    }
  }
}
