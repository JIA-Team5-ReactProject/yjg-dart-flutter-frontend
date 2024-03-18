import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/shared/constants/api_url.dart';

class AdminCategoryDataSource {
  String getApiUrl() {
    // 상수 파일에서 가져온 apiURL 사용
    return apiURL;
  }

  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

// * 카테고리 생성
  Future<http.Response> postCategoryAPI(String categoryName) async {
    final token = await storage.read(key: 'auth_token');
    String url = '$apiURL/api/salon/category';
    final body = jsonEncode({
      'category' : categoryName
    });

    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);

    if (response.statusCode == 201) {
      return response;
    } else {
      debugPrint('카테고리 등록 실패: ${response.statusCode}, ${jsonDecode(utf8.decode(response.bodyBytes))}');
      throw Exception('카테고리 등록에 실패했습니다.');
    }
  }

  // * 카테고리 수정
  Future<http.Response> patchCategoryAPI(
      int categoryId, String? categoryNaame) async {
    final token = await storage.read(key: 'auth_token');
    String url = '$apiURL/api/salon/category';
    final body = jsonEncode({
      'category_id': categoryId,
      'category': categoryNaame,
    });

    debugPrint('서비스 수정: $body');
    final response = await http.patch(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);

    debugPrint('카테고리 수정 결과: ${response.statusCode}, ${response.body}');

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('카테고리 수정에 실패했습니다.');
    }
  }

  // * 카테고리 삭제
  Future<http.Response> deleteCategoryAPI(int categoryId) async {
    final token = await storage.read(key: 'auth_token');
    String baseUrl = '$apiURL/api/salon/category';

    final response = await http.delete(
      Uri.parse('$baseUrl/$categoryId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('카테고리 삭제 결과: ${response.statusCode}, ');

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('카테고리 삭제에 실패했습니다.');
    }
  }
}
