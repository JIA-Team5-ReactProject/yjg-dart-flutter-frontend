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

    final data = {
      "student_id": detailRegisterState.studentId,
      "name": detailRegisterState.name,
      "phone_number": detailRegisterState.phoneNumber,
      "password": detailRegisterState.password,
      "new_password": detailRegisterState.newPassword,
    };

    try {
      final response = await dio.patch(url, data: data);

      debugPrint('추가 정보 입력 결과: ${response.data} ${response.statusCode}');
      return response;
    } catch (e) {
      debugPrint('통신 결과: $e');
      throw Exception('추가 정보 입력에 실패했습니다.');
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
    } catch (e) {
      debugPrint('통신 결과: $e');
      throw Exception('approve 변경에 실패했습니다.');
    }
  }
}
