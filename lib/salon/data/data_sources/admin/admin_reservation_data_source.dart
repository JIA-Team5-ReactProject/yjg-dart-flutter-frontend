import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/shared/constants/api_url.dart';

class AdminReservationDataSource {
  String getApiUrl() {
    // 상수 파일에서 가져온 apiURL 사용
    return apiURL;
  }

  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  // * 예약 목록 불러오기
  Future<List<dynamic>> getReservations(String reservationDate) async {
    final token = await storage.read(key: 'auth_token');

    // reservationDate를 쿼리스트링으로 추가
    final Uri uri =
        Uri.parse('$apiURL/api/salon/reservation?r_date=$reservationDate');

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('예약 목록: ${jsonDecode(utf8.decode(response.bodyBytes))}, ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      
      return data['reservations'];
    } else {
      throw Exception('예약 목록을 불러오는데 실패했습니다.');
    }
  }

  // * 예약 상태 변경하기
  Future<http.Response> changeReservationState(int reservationId, bool isConfirm) async {
    final token = await storage.read(key: 'auth_token');
    final Uri uri = Uri.parse('$apiURL/api/salon/reservation');

    final response = await http.patch(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'id': reservationId,
        'status': isConfirm,
      }),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('예약 상태 변경에 실패했습니다.');
    }
  }
}
