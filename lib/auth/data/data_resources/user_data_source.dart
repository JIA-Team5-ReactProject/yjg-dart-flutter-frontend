import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/auth/data/data_resources/google_login_data_source.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class UserDataSource {
  static final Dio dio = Dio();

  UserDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  final storage = FlutterSecureStorage();

  // * 추가 정보 입력 및 개인정보 수정
  Future<Response> patchAdditionalInfoAPI(WidgetRef ref, change) async {
    String url = '$apiURL/api/user';
    final loginType = await storage.read(key: 'login_type'); // 구글 로그인인지 확인
    final approve =
        await storage.read(key: 'approve'); // approve 확인(0일 경우, 승인 처리를 해야 하므로)
    debugPrint('보내는 데이터: $change');

    try {
      final response = await dio.patch(url, data: change);
      // google 로그인 시 approve 변경
      if (loginType == 'google' && approve == '0') {
        patchApproveAPI(); // approve 변경

        // 더 이상 사용하지 않는 approve 삭제
        await storage.delete(key: 'approve');

        // 구글 로그아웃
        GoogleLoginDataSource().logoutWithGoogle();
      }
      debugPrint('response data: ${response.data}, status code: ${response.statusCode}');

      return response;
    } on DioException catch (e) {
      throw Exception('추가 정보 입력에 실패했습니다. : $e');
    } catch (e) {
      throw Exception('알 수 없는 오류가 발생했습니다. : $e');
    }
  }

  // * 관리자 개인정보 수정
  Future<Response> patchAdminInfoAPI(WidgetRef ref, change) async {
    String url = '$apiURL/api/admin';

    try {
      final response = await dio.patch(url, data: change);

      return response;
    } on DioException catch (e) {
      debugPrint('코드: ${e.response!.statusCode} 데이터: ${e.response!.data}');
      throw Exception('개인정보 수정에 실패하였습니다. : $e');
    } catch (e) {
      throw Exception('알 수 없는 오류가 발생했습니다. : $e');
    }
  }

  // * 회원탈퇴
  Future<Response> deleteUserAccountAPI() async {
    String url = '$apiURL/api/unregister';
    final loginType = await storage.read(key: 'login_type');

    try {
      final response = await dio.delete(url);

      // 구글 로그인 시 구글 로그아웃
      if (loginType == 'google') {
        GoogleLoginDataSource().logoutWithGoogle();
      }

      storage.deleteAll(); // 모든 정보 삭제

      return response;
    } catch (e) {
      throw Exception('계정 탈퇴에 실패하였습니다. : $e');
    }
  }

  // * approve 변경
  Future<Response> patchApproveAPI() async {
    final data = {"approve": true};

    final url = '$apiURL/api/user/approve';

    try {
      final response = await dio.patch(url, data: data);

      return response;
    } on DioException catch (e) {
      throw Exception('추가 정보 입력에 실패했습니다. : $e');
    } catch (e) {
      throw Exception('알 수 없는 오류가 발생했습니다. : $e');
    }
  }
}
