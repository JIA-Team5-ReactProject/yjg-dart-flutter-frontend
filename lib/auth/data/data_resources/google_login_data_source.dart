import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yjg/auth/data/models/user.dart';
import 'package:yjg/auth/domain/usecases/domain_validation_usecase.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/main.dart';
import 'package:yjg/setting/data/data_sources/fcm_token_datasource.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';
import 'package:yjg/shared/service/save_to_storage.dart';

class GoogleLoginDataSource {
  static final _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  static final Dio dio = Dio();
  static final storage = FlutterSecureStorage();
  GoogleLoginDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * 구글 로그인 함수
  Future<void> signInWithGoogle(WidgetRef ref, BuildContext context) async {
    try {
      await _googleSignIn.signIn(); // 구글 로그인
      final GoogleSignInAccount? account =
          _googleSignIn.currentUser; // 로그인한 계정 정보

      // 이메일 도메인이 학교 이메일인지 확인
      final domainValidationUseCase = DomainValidationUseCase();

      if (account != null) {
        if (!domainValidationUseCase(account.email)) {
          _showSnackBar(context, '학교 이메일(@g.yju.ac.kr)이 아닐 경우 로그인을 할 수 없습니다.');
          await _googleSignIn.disconnect();
          return;
        }

        // 구글 로그인 정보
        GoogleSignInAuthentication googleAuth = await account.authentication;

        // 사용자 정보 업데이트
        ref.read(userProvider.notifier).updateWithGoogleSignIn(
              email: account.email,
              displayName: account.displayName,
              idToken: googleAuth.idToken,
            );

        // 토큰 교환 API 호출
        await _postGoogleLoginAPI(ref);
      }
    } catch (error) {
      debugPrint('signInWithGoogle 오류 발생: $error');
    }
  }

  // * 구글 로그아웃
  Future<void> logoutWithGoogle() async {
    _googleSignIn.signOut();
    debugPrint('구글 로그아웃 완료');
  }

  // * 구글 로그인 후 자체 토큰 교환 API
  Future<void> _postGoogleLoginAPI(WidgetRef ref) async {
    final loginState =
        ref.read(userProvider.notifier); // 로그인한 유저 정보(토큰 교환을 위한 정보)
    final deviceInfo = await storage.read(
        key: 'deviceType'); // 디바이스 정보(ios와 android 클라이언트 id가 다르므로 디바이스 정보로 식별)
    String url = '$apiURL/api/user/google-login';

    final data = {
      'email': loginState.email,
      'displayName': loginState.displayName,
      'id_token': loginState.idToken,
      'os_type': deviceInfo ?? 'unknown',
    };
    
    try {
      final response = await dio.post(url,
          data: data,
          options: Options(
              extra: {"noAuth": true})); // noAuth : AccessToken을 사용하지 않는 API

      final result = Usergenerated.fromJson(response.data); // 사용자 정보 파싱

      String? token = result.accessToken; // 토큰
      int? approved = result.user?.approved; // 사용자 승인 여부

      if (token != null) {
        // 스토리지에 토큰과 사용자 정보 저장
        await saveToStorage({
          'auth_token': token,
          'refresh_token': result.refreshToken!,
          'login_type': 'google'
        });
      } else {
        throw Exception('토큰이 없습니다.');
      }

      // 만약 승인이 되지 않았다면 사용자 정보 입력 페이지로 이동
      if (approved == 0) {
        // approve 저장
        await saveToStorage({
          'approve': '0',
        });

        navigatorKey.currentState!.pushNamed('/registration_detail');
      } else if (approved == 1) {
        // 승인이 되었다면 사용자 기본 정보 업데이트
        await saveToStorage({
          'name': result.user!.name!,
          'student_num': result.user!.studentId!,
          'phone_num': result.user!.phoneNumber!,
          'auto_login': "true", // 구글 로그인 시 자동 로그인 고정
          'userType': 'student',
        });

        // FCM 토큰 업데이트
        FcmTokenDataSource().patchFcmTokenAPI();

        // 로그인 성공 시 메인 대시보드로 이동
        navigatorKey.currentState!.pushReplacementNamed('/dashboard_main');
      }
    } on DioException catch (e) {
      debugPrint('${e.response}, 코드: ${e.response?.statusCode}');
    } catch (e) {
      debugPrint('비HTTP 에러 발생: $e');
    }
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
}