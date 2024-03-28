import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/shared/constants/api_url.dart';

class UrgentDataSource {
  String getApiUrl() {
    // 상수 파일에서 가져온 apiURL 사용
    return apiURL;
  }

  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

// * 최근 공지사항
  Future<http.Response> getUrgentApi() async {
    final token = await storage.read(key: 'auth_token');
    String url = '$apiURL/api/notice/recent/urgent';

    Uri uri = Uri.parse(url);

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
      throw Exception('최근 공지 데이터 가져오기에 실패하였습니다.');
    }
  }
}
