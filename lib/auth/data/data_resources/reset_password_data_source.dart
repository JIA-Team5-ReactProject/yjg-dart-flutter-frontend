import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/auth/presentation/viewmodels/verify_code_viewmodel.dart';
import 'package:yjg/shared/constants/api_url.dart';

class ResetPasswordDataSource {
  // 비밀번호 찾기 메일

  Future<http.Response> postResetPasswordAPI(WidgetRef ref) async {
    final loginState = ref.read(userProvider.notifier);

    final body = jsonEncode(<String, String>{
      'email': loginState.email,
      'name': loginState.name,
    });

    // 통신
    final response = await http.post(
      Uri.parse('$apiURL/api/user/reset-password'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body,
      // state 값을 json 형태로 변환
    );

    debugPrint('결과: ${jsonDecode(utf8.decode(response.bodyBytes))}');

    if (response.statusCode != 200) {
      debugPrint('실패: ${response.statusCode}');
    }
    return response;
  }

  // 인증번호 검증
  Future<http.Response> postResetPasswordMailVerifyAPI(
      WidgetRef ref) async {
    final verifyCode = ref.watch(verifyCodeProvider.notifier).state;
    final loginState = ref.watch(userProvider.notifier);

    final url = '$apiURL/api/reset-password/verify';

    Map<String, String> queryParams = {
      'code': verifyCode.toString(),
      'email': loginState.email,
    };

    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);
    debugPrint('uri: $uri');

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    debugPrint('결과: ${jsonDecode(utf8.decode(response.bodyBytes))}');

    // status code가 200이 아닐 경우
    if (response.statusCode != 200 && response.statusCode != 201) {
      debugPrint('실패: ${response.statusCode}');
    }

    return response;
  }
}
