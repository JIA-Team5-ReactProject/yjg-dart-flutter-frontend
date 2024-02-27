import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/shared/constants/api_url.dart';

class UserDataSource {
  // 유저 정보 호출
  
  // approve 변경
  Future<http.Response> patchApproveAPI(String token) async {
    final body = jsonEncode(<String, bool>{"approve": true});
    debugPrint('내가 보내는 값: $body');
    debugPrint('토큰: $token');
    final uri = Uri.parse('$apiURL/api/user/approve');
    final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{"approve": true}));

    if (response.statusCode == 200) {
      // 성공적으로 데이터를 받아옴
      debugPrint('patchApproveAPI 호출 성공');
      debugPrint(response.body);
      return response;
    } else {
      // 오류 처리
      debugPrint(response.body);
      throw Exception('업데이트 실패: ${response.statusCode} ${response.body}');
    }
  }
}
