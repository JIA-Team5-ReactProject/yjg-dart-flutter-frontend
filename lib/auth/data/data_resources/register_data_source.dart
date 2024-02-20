import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/constants/api_url.dart';

// 회원가입 통신

class RegisterDataSource {
  Future<http.Response> postRegisterAPI(WidgetRef ref) async {

    // state 값 가져오기
    final registerState = ref.read(userProvider.notifier);
 final body = jsonEncode(<String, String>{
        'email': registerState.email,
        'password': registerState.password,
        'name': registerState.name,
        'phone_number': registerState.phoneNumber,
      });

    // 통신
    final response = await http.post(
      Uri.parse('$apiURL/api/user/foreigner'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },

     
      // state 값을 json 형태로 변환
      body: jsonEncode(<String, String>{
        'email': registerState.email,
        'password': registerState.password,
        'name': registerState.name,
        'phone_number': registerState.phoneNumber,
      }),


    );
      print(body);

    // status code가 200이 아닐 경우
    if (response.statusCode != 201) {
      throw Exception('회원가입 실패: ${response.statusCode}');
    }
    
    print(response.body);
    return response;
  }
}