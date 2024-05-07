import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/auth/data/models/user.dart';
import 'package:yjg/auth/presentation/viewmodels/privilege_viewmodel.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/setting/data/data_sources/fcm_token_datasource.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';
import 'package:yjg/shared/service/save_to_storage.dart';

class LoginDataSource {
  static final Dio dio = Dio();
  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  LoginDataSource() {
    dio.interceptors.add(DioInterceptor(dio)); // 수정된 생성자를 사용
  }

  //* 외국인 유학생 로그인
  Future<Map<String, dynamic>> postStudentLoginAPI(WidgetRef ref) async {
    final loginState = ref.read(userProvider.notifier);
    final url = '$apiURL/api/user/login';
    final data = {
      'email': loginState.email,
      'password': loginState.password,
    };

    try {
      final response = await dio.post(url,
          data: data, options: Options(extra: {"noAuth": true}));
      Usergenerated userGenerated = Usergenerated.fromJson(response.data);

      // 스토리지에 토큰과 사용자 정보 저장
      await saveToStorage({
        'auth_token': userGenerated.accessToken!,
        'refresh_token': userGenerated.refreshToken!,
        'name': userGenerated.user!.name!,
        'student_id': userGenerated.user!.studentId!,
        'phone_number': userGenerated.user!.phoneNumber!,
      });

      debugPrint('토큰 저장: ${userGenerated.accessToken}');
      debugPrint('리프레시 토큰 저장: ${userGenerated.refreshToken}');

      // FCM 토큰 업데이트
      FcmTokenDataSource().patchFcmTokenAPI();

      return response.data;
    } catch (e) {
      debugPrint('통신 결과: $e');
      throw Exception('로그인에 실패했습니다.');
    }
  }

// * 관리자 로그인
  Future<Map<String, dynamic>> postAdminLoginAPI(WidgetRef ref) async {
    final loginState = ref.read(userProvider.notifier);
    final url = '$apiURL/api/admin/login';
    final data = {
      'email': loginState.email,
      'password': loginState.password,
    };

    try {
      final response = await dio.post(url,
          data: data, options: Options(extra: {"noAuth": true}));

      final result = Usergenerated.fromJson(response.data);
      String? token = result.accessToken; // 토큰값 추출
      String? refreshToken = result.refreshToken; // 리프레시 토큰값 추출

      if (token != null) {
        // 스토리지에 토큰과 사용자 정보 저장
        await saveToStorage({
          'auth_token': result.accessToken!,
          'refresh_token': result.refreshToken!,
          'name': result.user!.name!,
          'phone_num': result.user!.phoneNumber!,
        });

        debugPrint('토큰 저장: $token');
        debugPrint('리프레시 토큰 저장: $refreshToken');

        // 관리자 권한 유형 관리
        if (result.user != null) {
          ref
              .read(adminPrivilegesProvider.notifier)
              .updatePrivileges(result.user!);
        }

        // FCM 토큰 업데이트
        FcmTokenDataSource().patchFcmTokenAPI();

        return response.data;
      } else {
        throw Exception('토큰이 없습니다.');
      }
    } catch (e) {
      debugPrint('통신 결과: $e');
      throw Exception('로그인에 실패했습니다.');
    }
  }

  //  * 리프레시 토큰 교환
  Future<String> getRefreshTokenAPI() async {
    final refreshToken = await storage.read(key: 'refresh_token');
    if (refreshToken == null) throw Exception("리프레시 토큰이 없습니다.");

    final url = '$apiURL/api/refresh';

    try {
      final response = await dio.get(
        url,
        options: Options(extra: {
          'useRefreshToken': true, // 리프레시 토큰 사용을 위한 플래그 설정
        }),
      );

      final accessToken = response.data['access_token'];
      if (accessToken != null) {
        await storage.write(key: 'auth_token', value: accessToken);
        debugPrint('리프레시 토큰 교환 완료, 액세스 토큰 교체: $accessToken');
        return accessToken;
      } else {
        throw Exception("액세스 토큰이 없습니다.");
      }
    } catch (e) {
      debugPrint('통신 결과: $e');
      throw Exception('리프레시 토큰 교환에 실패했습니다.');
    }
  }
}
