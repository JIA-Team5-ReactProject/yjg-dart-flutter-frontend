import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/shared/constants/api_url.dart';

class AsCommentDataSource {
  String getApiUrl() {
    // 상수 파일에서 가져온 apiURL 사용
    return apiURL;
  }

  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

// * 댓글 로드
  Future<http.Response> getCommentAPI(int serviceId) async {
    final token = await storage.read(key: 'auth_token');
    String url = '$apiURL/api/after-service/${serviceId.toString()}/comment';

    final response = await http.get(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

    debugPrint('댓글 로드 결과: ${response.statusCode}, ${response.body}');
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('댓글 로드에 실패했습니다.');
    }
  }


// * 댓글 등록
  Future<http.Response> postCommentAPI(int serviceId, String comment) async {
    final token = await storage.read(key: 'auth_token');
    String url = '$apiURL/api/after-service/${serviceId.toString()}/comment';
    final body = jsonEncode({
      'comment' : comment,
    });

    debugPrint('댓글 등록 body: $body');
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);

    debugPrint('댓글 등록 결과: ${response.statusCode}, ${response.body}');
    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception('댓글 작성에 실패했습니다.');
    }
  }

  // * 댓글 수정
  Future<http.Response> patchCommentAPI(
      int commentId, String comment) async {
    final token = await storage.read(key: 'auth_token');
    String url = '$apiURL/api/after-service/comment/${commentId.toString()}';

    final body =
        jsonEncode({'comment': comment});



    final response = await http.patch(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('댓글 수정에 실패했습니다.');
    }
  }

  // * 댓글 삭제
  Future<http.Response> deleteCommentAPI(int commentId) async {
    final token = await storage.read(key: 'auth_token');
    String baseUrl = '$apiURL/api/after-service/comment/${commentId.toString()}';

    final response = await http.delete(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('댓글 삭제 결과: ${response.statusCode}, ');

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('댓글 삭제에 실패했습니다.');
    }
  }
}
