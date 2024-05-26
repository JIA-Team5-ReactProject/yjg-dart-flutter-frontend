import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class AsCommentDataSource {
  static final Dio dio = Dio(); // Dio 인스턴스 생성
  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

    AsCommentDataSource() {
    dio.interceptors.add(DioInterceptor(dio)); // 수정된 생성자를 사용
  }

  // * 댓글 로드
  Future<Response> getCommentAPI(int serviceId) async {
    String url = '$apiURL/api/after-service/${serviceId.toString()}/comment';

    try {
      // dio 인스턴스를 사용하여 get 요청
      final response = await dio.get(url);
      debugPrint('댓글 로드 결과: ${response.statusCode}, ${response.data}');

      return response;
    } catch (e) {
      throw Exception('댓글 로드에 실패했습니다.');
    }
  }

// * 댓글 등록
  Future<Response> postCommentAPI(int serviceId, String comment) async {
    String url = '$apiURL/api/after-service/${serviceId.toString()}/comment';

    try {
      final response = await dio.post(url, data: {'comment': comment});
      debugPrint('댓글 등록 결과: ${response.statusCode}, ${response.data}');
      return response;
    } on DioException catch (e) {
      debugPrint('댓글 작성 실패: ${e.response!.statusCode}, ${e.response!.data}');
      throw Exception('댓글 작성에 실패했습니다. : $e');
    } 
    
    catch (e) {
      throw Exception('댓글 작성에 실패했습니다.');
    }
  }

  // * 댓글 수정
  Future<Response> patchCommentAPI(int commentId, String comment) async {
    String url = '$apiURL/api/after-service/comment/${commentId.toString()}';

    try {
      final response = await dio.patch(url, data: {'comment': comment});
      debugPrint('댓글 수정 결과: ${response.statusCode}, ${response.data}');
      return response;
    } catch (e) {
      throw Exception('댓글 수정에 실패했습니다.');
    }
  }

  // * 댓글 삭제
  Future<Response> deleteCommentAPI(int commentId) async {
    String url = '$apiURL/api/after-service/comment/${commentId.toString()}';

    try {
      final response = await dio.delete(url);

      debugPrint('댓글 삭제 결과: ${response.statusCode}, ');
      return response;
    } catch (e) {
      throw Exception('댓글 삭제에 실패했습니다.');
    }
  }
}
