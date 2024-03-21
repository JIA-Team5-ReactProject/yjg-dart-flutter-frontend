import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/shared/constants/api_url.dart';

class MyBookingDataSource {
  String getApiUrl() {
    // 상수 파일에서 가져온 apiURL 사용
    return apiURL;
  }

  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  Future<http.Response> getReservationAPI() async {
    final token = await storage.read(key: 'auth_token');
    String url = '$apiURL/api/salon/reservation/user';

    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('예약 목록: ${jsonDecode(utf8.decode(response.bodyBytes))}, ${response.statusCode}');
    if (response.statusCode == 200) {
      // 예약이 있는 경우

      return response;
    } else {
      throw Exception('예약 목록을 불러오지 못했습니다.');
    }
  }
}
