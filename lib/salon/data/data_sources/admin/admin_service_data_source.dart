import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/shared/constants/api_url.dart';

class AdminServiceDataSource {
  String getApiUrl() {
    // 상수 파일에서 가져온 apiURL 사용
    return apiURL;
  }

  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

// * 서비스 생성
  Future<http.Response> postServiceAPI(int categoryId, String? serviceName,
      String? gender, String? price) async {
    final token = await storage.read(key: 'auth_token');
    String url = '$apiURL/api/salon/service';
    final body = jsonEncode({
      'category_id': categoryId,
      'service': serviceName,
      "gender": gender,
      "price": price
    });

    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('서비스 수정에 실패했습니다.');
    }
  }

  // * 서비스 수정
  Future<http.Response> patchServiceAPI(
      int serviceId, String? serviceName, String? gender, String? price) async {
    final token = await storage.read(key: 'auth_token');
    String url = '$apiURL/api/salon/service/$serviceId';

    final body =
        jsonEncode({'service': serviceName, "gender": gender, "price": price});

    final response = await http.patch(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);

    debugPrint('서비스 수정 결과: ${response.statusCode},');

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('서비스 수정에 실패했습니다.');
    }
  }

  // * 서비스 삭제
  Future<http.Response> deleteServiceListAPI(int serviceId) async {
    final token = await storage.read(key: 'auth_token');
    String baseUrl = '$apiURL/api/salon/service';

    final response = await http.delete(
      Uri.parse('$baseUrl/$serviceId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('서비스 삭제 결과: ${response.statusCode}, ');

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('서비스 삭제에 실패했습니다.');
    }
  }
}
