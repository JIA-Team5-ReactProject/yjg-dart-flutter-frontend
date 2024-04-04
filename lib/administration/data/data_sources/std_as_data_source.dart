import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class StdAsDataSource {
  static final storage = FlutterSecureStorage();
  static final Dio dio = Dio();

  StdAsDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * 예약 AS get 함수
  Future<Response> fetchLatestASRequest() async {
    String url = '$apiURL/api/after-service/user';

    try {
      final response = await dio.get(url);
      return response;
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('예약 AS를 불러오지 못했습니다.');
    }
  }

  // * 예약 AS post 함수
  Future<void> sendData(title, input, place, day, List<XFile> images) async {
    final url = '$apiURL/api/after-service';
    final formData = FormData();

    // 필드 추가
    formData.fields
      ..add(MapEntry('title', title))
      ..add(MapEntry('content', input))
      ..add(MapEntry('visit_place', place))
      ..add(MapEntry('visit_date', day));

    // 이미지 파일을 요청에 추가
    for (var image in images) {
      formData.files.add(
        MapEntry(
          'images[]',
          await MultipartFile.fromFile(image.path,
              filename: image.path.split('/').last),
        ),
      );
    }

    try {
      final response = await dio.post(url, data: formData);
      debugPrint('통신 결과: $response');
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('예약 AS를 등록하지 못했습니다.');
    }
  }

  // * AS 카드 데이터를 불러오는 함수
  Future<Response> fetchASRequests() async {
    String url = '$apiURL/api/after-service/user';

    try {
      final response = await dio.get(url);
      return response;
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('AS 요청을 불러오지 못했습니다.');
    }
  }
}
