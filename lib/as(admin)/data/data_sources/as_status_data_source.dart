
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/shared/constants/api_url.dart';

class StatusDataSource {
  String getApiUrl() {
    // 상수 파일에서 가져온 apiURL 사용
    return apiURL;
  }

  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

// * 상태 변경
  Future<http.Response> patchStatusAPI(int serviceId) async {
    final token = await storage.read(key: 'auth_token');
    String url = '$apiURL/api/after-service/status/${serviceId.toString()}';

    final response = await http.patch(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },);

    debugPrint('상태 변경 결과: ${response.statusCode}, ${response.body}');
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('상태 변경에 실패했습니다.');
    }
  }
}
