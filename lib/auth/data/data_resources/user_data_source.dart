import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class UserDataSource {
  // 유저 정보 호출
  static final Dio dio = Dio();

  UserDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // 추가 정보 입력 및 개인정보 수정
  Future<Response> patchAdditionalInfoAPI(WidgetRef ref, change) async {
    String url = '$apiURL/api/user';

    try {
      final response = await dio.patch(url, data: change);

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

  // 관리자 개인정보 수정
  Future<Response> patchAdminInfoAPI(WidgetRef ref, change) async {
    String url = '$apiURL/api/admin';

    try {
      final response = await dio.patch(url, data: change);

      debugPrint('추가 정보 입력 결과: ${response.data} ${response.statusCode}');
      return response;
    } on DioException catch (e) {
      debugPrint('서버 오류 메시지: ${e.response?.data}');
      debugPrint('서버 상태 코드: ${e.response?.statusCode}');
      throw Exception('개인정보 수정에 실패하였습니다');
    } catch (e) {
      debugPrint('예상치 못한 오류: $e');
      throw Exception('알 수 없는 오류가 발생했습니다.');
    }
  }


  // 회원탈퇴
  Future<Response> deleteUserAccountAPI() async {
    String url = '$apiURL/api/unregister';

    try {
      final response = await dio.delete(url);

      debugPrint('계정 삭제 결과: ${response.data} ${response.statusCode}');
      return response;
    } catch (e) {
      debugPrint('예상치 못한 오류: $e');
      throw Exception('계정 탈퇴에 실패하였습니다..');
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
