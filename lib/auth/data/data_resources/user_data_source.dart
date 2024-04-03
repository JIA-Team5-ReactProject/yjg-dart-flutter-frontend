import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class UserDataSource {
  // 유저 정보 호출
  static final Dio dio = Dio();

  UserDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // 추가 정보 입력
  Future<Response> patchAdditionalInfoAPI(WidgetRef ref) async {
    // state 값 가져오기
    final detailRegisterState = ref.read(userProvider.notifier);
    String url = '$apiURL/api/user';

    Map<String, dynamic> data = {}
      ..addAll(detailRegisterState.studentId.isNotEmpty == true
          ? {"student_id": detailRegisterState.studentId}
          : {})
      ..addAll(detailRegisterState.phoneNumber.isNotEmpty == true
          ? {"phone_number": detailRegisterState.phoneNumber}
          : {})
      ..addAll(detailRegisterState.name.isNotEmpty == true
          ? {"name": detailRegisterState.name}
          : {})
      ..addAll(detailRegisterState.password.isNotEmpty == true
          ? {"current_password": detailRegisterState.password}
          : {})
      ..addAll(detailRegisterState.newPassword.isNotEmpty == true
          ? {"new_password": detailRegisterState.newPassword}
          : {});

    debugPrint('추가 정보 입력: $data');

    try {
      final response = await dio.patch(url, data: data);

      debugPrint('추가 정보 입력 결과: ${response.data} ${response.statusCode}');

      // approve 변경
      patchApproveAPI();
      return response;
    } on DioException catch (e) {
      debugPrint('서버 오류 메시지: ${e.response?.data}');
      debugPrint('서버 상태 코드: ${e.response?.statusCode}');
      throw Exception('추가 정보 입력에 실패했습니다.');
    } catch (e) {
      // 다른 모든 예외를 캐치
      debugPrint('예상치 못한 오류: $e');
      throw Exception('알 수 없는 오류가 발생했습니다.');
    }
  }

  // approve 변경
  Future<Response> patchApproveAPI() async {
    final data = {"approve": true};

    final url = '$apiURL/api/user/approve';

    try {
      final response = await dio.patch(url, data: data);

      debugPrint('patchApproveAPI 호출 성공');
      return response;
    } on DioException catch (e) {
      debugPrint('서버 오류 메시지: ${e.response?.data}');
      debugPrint('서버 상태 코드: ${e.response?.statusCode}');
      throw Exception('추가 정보 입력에 실패했습니다.');
    } catch (e) {
      // 다른 모든 예외를 캐치
      debugPrint('예상치 못한 오류: $e');
      throw Exception('알 수 없는 오류가 발생했습니다.');
    }
  }
}
