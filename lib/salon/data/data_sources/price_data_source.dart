import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/shared/constants/api_url.dart';

class PriceDataSource {
  String getApiUrl() {
    // 상수 파일에서 가져온 apiURL 사용
    return apiURL;
  }

  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  // * 카테고리 목록 불러오기
  Future<http.Response> getCategoryListAPI() async {
    final token = await storage.read(key: 'auth_token');
    String url = '$apiURL/api/salon/category';

    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('카테고리 목록을 불러오지 못했습니다.');
    }
  }

  // 카테고리별 서비스 목록 불러오기
  Future<String> getServiceListAPI(
      String selectedGender, int selectedCategoryId) async {
    final token = await storage.read(key: 'auth_token');
    String baseUrl = '$apiURL/api/salon/service';

    Map<String, String> queryParams = {
      'category_id': selectedCategoryId.toString(),
      'gender': selectedGender
    };

    Uri uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('서비스 목록을 불러오지 못했습니다.');
    }
  }
}
