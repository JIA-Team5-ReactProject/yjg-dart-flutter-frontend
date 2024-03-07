import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/auth/data/data_resources/user_data_source.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/constants/api_url.dart';

class RegisterDataSource {
  // 일반 회원가입
  Future<http.Response> postRegisterAPI(WidgetRef ref) async {
    // state 값 가져오기
    final registerState = ref.read(userProvider.notifier);

    final body = jsonEncode(<String, String>{
      'email': registerState.email,
      'password': registerState.password,
      'name': registerState.name,
      'phone_number': registerState.phoneNumber,
      'student_id': registerState.studentId,
    });

    debugPrint('내가 보낸 body: $body');

    // 통신
    final response = await http.post(
      Uri.parse('$apiURL/api/user'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body,
      // state 값을 json 형태로 변환
    );

    debugPrint('결과: ${response.body}');
    // status code가 200이 아닐 경우
    if (response.statusCode != 201) {
      throw Exception('회원가입 실패: ${response.statusCode}');
    }
    return response;
  }

  // 추가 정보 입력
  Future<http.Response> patchAdditionalInfoAPI(
      WidgetRef ref, String token) async {
    // state 값 가져오기
    final detailRegisterState = ref.read(userProvider.notifier);
    debugPrint('토큰: $token');

    final body = jsonEncode(<String, dynamic>{
      "student_id": detailRegisterState.studentId,
      "name": detailRegisterState.name,
      "phone_number": detailRegisterState.phoneNumber,
    });

    final response = await http.patch(Uri.parse('$apiURL/api/user'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // state 값을 json 형태로 변환
        body: body);

    debugPrint(body);

    // status code가 200이 아닐 경우
    if (response.statusCode != 200) {
      throw Exception('추가 정보 입력 실패: ${response.statusCode}');
    } else {
      UserDataSource().patchApproveAPI(token!);
    }

    return response;
  }

  // 이메일 중복 검사 API 호출
  Future<bool> checkEmailDuplicate(String email) async {
    try {
      final uri = Uri.parse('$apiURL/api/user/verify-email/$email');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        debugPrint(response.body);
        return false;
      } else {
        return true;
      }
    } catch (e) {
      throw Exception("이메일 중복 검사 중 오류 발생: $e");
    }
  }
}
