import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/auth/data/models/user.dart';
import 'package:yjg/auth/domain/usecases/domain_validation_usecase.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/main.dart';
import 'package:yjg/shared/constants/api_url.dart';

class GoogleLoginDataSource {
  static final _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  static final _storage = FlutterSecureStorage();

  // 구글로 로그인하는 함수
  Future<void> signInWithGoogle(WidgetRef ref, BuildContext context) async {
    try {
      await _googleSignIn.signIn();
      final GoogleSignInAccount? account = _googleSignIn.currentUser;
      final domainValidationUseCase = DomainValidationUseCase();

      // 이메일 도메인이 학교 이메일인지 확인
      if (account != null) {
        if (!domainValidationUseCase(account.email)) {
          _showSnackBar(context, '학교 이메일(@g.yju.ac.kr)이 아닐 경우 로그인을 할 수 없습니다.');
          await _googleSignIn.disconnect();
          return;
        }

        // 구글 로그인 후 토큰을 교환
        GoogleSignInAuthentication googleAuth = await account.authentication;

        ref.read(userProvider.notifier).updateWithGoogleSignIn(
              email: account.email,
              displayName: account.displayName,
              idToken: googleAuth.idToken,
            );

        await _postGoogleLoginAPI(ref);
      }
    } catch (error) {
      debugPrint('signInWithGoogle 오류 발생: $error');
    }
  }

  // 구글로 로그인 후 토큰을 교환하는 함수
  Future<void> _postGoogleLoginAPI(WidgetRef ref) async {
    try {
      final loginState = ref.read(userProvider.notifier);
      final deviceInfo = await _storage.read(key: 'deviceType');
      final body = jsonEncode(<String, String>{
        'email': loginState.email,
        'displayName': loginState.displayName,
        'id_token': loginState.idToken,
        'os_type': deviceInfo ?? 'unknown',
      });

      debugPrint('body: $body');

      final response = await http.post(
        Uri.parse('$apiURL/api/user/google-login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: body,
      );


      debugPrint('결과: ${jsonDecode(utf8.decode(response.bodyBytes)) }');
      debugPrint('status code: ${response.statusCode}');
      final result = Usergenerated.fromJson(jsonDecode(response.body));
      int? approved = result.user?.approved;

      if (response.statusCode == 403 || approved == 0) {
        navigatorKey.currentState!.pushNamed('/registration_detail');
      }

      if (response.statusCode != 200) {
        throw HttpException(
            'Failed to post Google login. Status code: ${response.statusCode}');
      }

      String? token = result.accessToken;
      String? refreshToken = result.refreshToken;
      String? studentNum = result.user?.studentId;
      String? name = result.user?.name;

      if (token != null) {
        await _saveTokens(token, refreshToken, studentNum, name!);
        debugPrint('token: $token, refreshToken: $refreshToken');
      } else {
        debugPrint('토큰이 없습니다.');
        throw Exception('토큰이 없습니다.');
      }
    } catch (e) {
      debugPrint('_postGoogleLoginAPI 오류 발생: $e');
      rethrow;
    }
  }

  // 토큰을 저장하는 함수
  Future<void> _saveTokens(String token, String? refreshToken,
      String? studentNum, String displayName) async {
    await _storage.write(key: 'auth_token', value: token);
    await _storage.write(key: 'name', value: displayName);
    await _storage.write(key: 'refresh_token', value: refreshToken ?? '');
    await _storage.write(key: 'student_num', value: studentNum ?? '');
  }

  // 스낵바를 표시하는 함수
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // 로그아웃하는 함수
  static Future<void> logout() => _googleSignIn.signOut();
}

void printLongString(String text) {
  final pattern = RegExp('.{1,1000}'); // 800글자 단위로 분할
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
