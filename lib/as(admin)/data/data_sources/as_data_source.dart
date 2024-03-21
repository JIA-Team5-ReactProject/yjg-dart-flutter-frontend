import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/shared/constants/api_url.dart';

class AsDataSource {
  String getApiUrl() {
    // 상수 파일에서 가져온 apiURL 사용
    return apiURL;
  }

  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

// * as 데이터
  Future<http.Response> getAsDataAPI(int status, int page) async {
    final token = await storage.read(key: 'auth_token');
    String url = '$apiURL/api/after-service';

    debugPrint('status: $status, page: $page');

    Map<String, String> queryParams = {
      'status': status.toString(),
      'page': page.toString(),
    };

    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    debugPrint('uri: $uri');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('AS 데이터 가져오기에 실패했습니다.');
    }
  }
}
