import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/constants/api_url.dart';

class LoginDataSource {
  // 구글 로그인 통신
  String getApiUrl() {
    return apiURL; // 상수 파일에서 가져온 apiURL 사용
  }

  static final _googleSignin = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  // 구글 로그인 통신
  Future<void> signInWithGoogle() async {
    try {
      await _googleSignin.signIn();
      final GoogleSignInAccount? account = _googleSignin.currentUser;

      if (account != null) {
        GoogleSignInAuthentication googleAuth = await account.authentication;

        // 액세스 토큰 출력
        print("Google User Token: ${googleAuth.accessToken}");
        print(account);
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  static Future<void> logout() => _googleSignin.signOut();

  // 일반 로그인 통신
  Future<http.Response> postLoginAPI(WidgetRef ref) async {
    final loginState = ref.read(userProvider.notifier);

    final response = await http.post(
      Uri.parse('$apiURL/api/user/foreigner/login'),
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
    print("로그인 통신 결과: ${response.body}, ${response.statusCode}");

    // 만약 200 통신이 아닐 경우
    if (response.statusCode != 200) {
      throw Exception('로그인 실패: ${response.statusCode}');
    }
    return response;
  }
}
