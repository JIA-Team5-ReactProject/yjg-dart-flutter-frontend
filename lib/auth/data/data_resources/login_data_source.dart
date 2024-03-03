import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/auth/data/models/admin_service.dart';
import 'package:yjg/auth/presentation/viewmodels/privilege_viewmodel.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/constants/api_url.dart';

class LoginDataSource {
  String getApiUrl() {
    // 상수 파일에서 가져온 apiURL 사용
    return apiURL;
  }

  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  // * 외국인 유학생 로그인
  Future<http.Response> postStudentLoginAPI(WidgetRef ref) async {
    final loginState = ref.read(userProvider.notifier);
    // 주소
    String url = '$apiURL/api/user/login';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': loginState.email,
        'password': loginState.password,
      }),
    );

    debugPrint("현재 라우트: $url");
    debugPrint("로그인 통신 결과: ${response.body}, ${response.statusCode}");

    if (response.statusCode == 200) {
      String token = response.body;

      if (token != null) {
        await storage.write(key: 'auth_token', value: token); // 토큰 저장
        debugPrint(
            '현재 토큰: ${await storage.read(key: 'auth_token')}'); // storage.~는 비동기 함수라서 await 사용해야 값이 정상적으로 출력됨
      } else {
        throw Exception('토큰이 없습니다.');
        // debugPrint('토큰이 없습니다.');
      }
    } else {
      throw Exception('로그인 실패: ${response.statusCode}');
    }
    return response;
  }

// * 관리자 로그인
  Future<http.Response> postAdminLoginAPI(WidgetRef ref) async {
    final loginState = ref.read(userProvider.notifier);

    // 주소
    String url = '$apiURL/api/admin/login';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': loginState.email,
        'password': loginState.password,
      }),
    );

    debugPrint("현재 라우트: $url");
    debugPrint("로그인 통신 결과: ${response.body}, ${response.statusCode}");

    if (response.statusCode == 200) {
      final result =
          Admingenerated.fromJson(jsonDecode(response.body)); // 토큰값 추출
      String? token = result.token;

      if (token != null) {
        await storage.write(key: 'auth_token', value: token);
        debugPrint('현재 토큰: ${await storage.read(key: 'auth_token')}');

        // 관리자 권한 업데이트 로직
        if (result.admin != null) {
          ref
              .read(adminPrivilegesProvider.notifier)
              .updatePrivileges(result.admin!);
        }
      } else {
        throw Exception('토큰이 없습니다.');
      }
    } else {
      throw Exception('로그인 실패: ${response.statusCode}');
    }
    return response;
  }
}
