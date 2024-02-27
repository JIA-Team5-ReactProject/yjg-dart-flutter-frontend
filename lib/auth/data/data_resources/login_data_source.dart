import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/constants/api_url.dart';

class LoginDataSource {
  // 상수 파일에서 가져온 apiURL 사용
  String getApiUrl() {
    return apiURL;
  }

  // 토큰 담는 곳
  static final storage = FlutterSecureStorage();

  // 일반 로그인 통신
  Future<http.Response> postLoginAPI(WidgetRef ref) async {
    final loginState = ref.read(userProvider.notifier);

    final response = await http.post(
      Uri.parse('$apiURL/api/user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      // Json 형태로 변환
      body: jsonEncode(<String, String>{
        'email': loginState.email,
        'password': loginState.password,
      }),
    );

    // 로그인 통신 결과 출력
    debugPrint("로그인 통신 결과: ${response.body}, ${response.statusCode}");

    // 만약 200 통신일 경우
    if (response.statusCode == 200) {
      String token = response.body;

      if (token != null) {
        // 토큰 저장        
        await storage.write(key: 'auth_token', value: token);
      } else {
        // throw Exception('토큰이 없습니다.');
        debugPrint('토큰이 없습니다.');
        
      }
      print('로그인 완료');
    } else {
      throw Exception('로그인 실패: ${response.statusCode}');
    }
    return response;
  }
}
