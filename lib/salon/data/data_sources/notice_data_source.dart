import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/salon/data/models/notice.dart';
import 'package:yjg/shared/constants/api_url.dart';

class NoticeDataSource {
  String getApiUrl() {
    // 상수 파일에서 가져온 apiURL 사용
    return apiURL;
  }

  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  Future<List<Notices>> getNoticeAPI() async {
    final token = await storage.read(key: 'auth_token');
    String url = '$apiURL/api/notice/recent';

    Map<String, String> queryParams = {
      'tag': 'salon',
    };

    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // JSON 문자열을 Noticegenerated 객체로 변환
      final noticeGenerated =
          Noticegenerated.fromJson(json.decode(response.body));

      // Noticegenerated 객체에서 notices 리스트를 반환
      return noticeGenerated.notices ?? [];
    } else {
      throw Exception('공지사항을 불러오는데 실패했습니다.');
    }
  }
}
