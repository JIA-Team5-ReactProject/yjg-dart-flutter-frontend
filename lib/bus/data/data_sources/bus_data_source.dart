import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/shared/constants/api_url.dart';

class BusDataSource {
  String getApiUrl() {
    // 상수 파일에서 가져온 apiURL 사용
    return apiURL;
  }

  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

// * 버스 데이터
  Future<http.Response> getBusDataAPI(int weekend, int semester, String route) async {
    final token = await storage.read(key: 'auth_token');
     String url = '$apiURL/api/bus/round/appSchedule';

    debugPrint('weekend: $weekend, semester: $semester, route: $route');

    Map<String, String> queryParams = {
      'weekend': weekend.toString(),
      'semester': semester.toString(),
      'bus_route_direction': route,
    }; 

    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    debugPrint('uri: $uri');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // debugPrint('response: ${jsonDecode(utf8.decode(response.bodyBytes))} ${response.statusCode}');

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('버스 데이터 가져오기에 실패했습니다.');
    }
  }
}
