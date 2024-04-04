import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/auth/data/models/user.dart';
import 'package:yjg/auth/presentation/viewmodels/privilege_viewmodel.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class LoginDataSource {
  static final Dio dio = Dio();
  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  LoginDataSource() {
      dio.interceptors.add(DioInterceptor(dio)); // 수정된 생성자를 사용
  }
  // 스토리지 모듈
  Future<void> _saveToStorage(Map<String, String> data) async {
    for (var key in data.keys) {
      await storage.write(key: key, value: data[key]);
    }
  }

  // 외국인 유학생 로그인
  Future<Map<String, dynamic>> postStudentLoginAPI(WidgetRef ref) async {
    final loginState = ref.read(userProvider.notifier);
    final url = '$apiURL/api/user/login';
    final data = {
      'email': loginState.email,
      'password': loginState.password,
    };

    try {
      final response = await dio.post(url, data: data, options: Options(extra: {"noAuth": true}));
      Usergenerated userGenerated = Usergenerated.fromJson(response.data);

      // 사용자 기본 정보 업데이트
      ref.read(userProvider.notifier).additionalInfoFormUpdate(
            name: userGenerated.user!.name!,
            phoneNumber: userGenerated.user!.phoneNumber!,
            studentId: userGenerated.user!.studentId!,
          );

      // 스토리지에 토큰과 사용자 정보 저장
      await _saveToStorage({
        'auth_token': userGenerated.accessToken!,
        'refresh_token': userGenerated.refreshToken!,
        'name': userGenerated.user!.name!,
        'student_num': userGenerated.user!.studentId!,
      });

      debugPrint('토큰 저장: ${userGenerated.accessToken}');
      debugPrint('리프레시 토큰 저장: ${userGenerated.refreshToken}');

      return response.data;
    } catch (e) {
      debugPrint('통신 결과: $e');
      throw Exception('로그인에 실패했습니다.');
    }
  }

// * 관리자 로그인
  Future<http.Response> postAdminLoginAPI(WidgetRef ref) async {
    final loginState = ref.read(userProvider.notifier);
    final url = '$apiURL/api/admin/login';
    final body = jsonEncode(<String, String>{
      'email': loginState.email,
      'password': loginState.password,
    });

    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: body);

    if (response.statusCode == 200) {
      final result = Usergenerated.fromJson(jsonDecode(response.body));
      String? token = result.accessToken; // 토큰값 추출
      String? refreshToken = result.refreshToken; // 리프레시 토큰값 추출

      if (token != null) {
        await storage.write(key: 'auth_token', value: token); // 토큰 저장
        await storage.write(
            key: 'refresh_token', value: refreshToken); // 리프레시 토큰 저장

        debugPrint('토큰 저장: $token');
        debugPrint('리프레시 토큰 저장: $refreshToken');

        // 관리자 권한 유형 관리
        if (result.user != null) {
          ref
              .read(adminPrivilegesProvider.notifier)
              .updatePrivileges(result.user!);
        }
      } else {
        throw Exception('토큰이 없습니다.');
      }
    } else {
      throw Exception('로그인 실패: ${response.statusCode}');
    }
    return response;
  }

  //  * 리프레시 토큰 교환
  Future<void> getRefreshTokenAPI() async {
    final storage = FlutterSecureStorage();
    debugPrint('토큰 만료: 리프레시 토큰 교환 시작');
    final refreshToken = await storage.read(key: 'refresh_token');
    final url = '$apiURL/api/refresh';
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $refreshToken',
      },
    );

    debugPrint('리프레시 토큰 교환 결과: ${response.statusCode}, ${response.body}');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final accessToken = responseData['access_token'];
      // 토큰 교체
      storage.write(key: 'auth_token', value: accessToken);
      debugPrint('리프레시 토큰 교환 완료, 액세스 토큰 교체: $accessToken');
    }
  }
}
