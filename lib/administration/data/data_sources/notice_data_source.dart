import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class NoticeDataSource {
  static final storage = FlutterSecureStorage();
  static final Dio dio = Dio();

  NoticeDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * 공지사항 불러오는 GET API
  Future<Response> fetchNotices(int page, String tag) async {
    String url = '$apiURL/api/notice?page=$page';
    try {
      final response = await dio.get(url);
      return response;
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('공지사항 로드에 실패했습니다.');
    }
  }

  // * 특정 공지사항 불러오는 GET API
  Future<Response> getNotice(int noticeId) async {
    String url = '$apiURL/api/notice/$noticeId';
    try {
      final response = await dio.get(url);
      return response;
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('공지사항 로드에 실패했습니다.');
    }
  }
}
