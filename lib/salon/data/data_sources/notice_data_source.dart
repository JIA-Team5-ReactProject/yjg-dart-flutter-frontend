import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/salon/data/models/notice.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class NoticeDataSource {
  static final Dio dio = Dio(); // Dio 인스턴스 생성
  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  NoticeDataSource() {
    dio.interceptors.add(DioInterceptor(dio)); // 수정된 생성자를 사용
  }

  Future<List<Notices>> getNoticeAPI() async {
    String url = '$apiURL/api/notice/recent';

    Map<String, String> queryParams = {
      'tag': 'salon',
    };

    try {
      final response = await dio.get(url, queryParameters: queryParams);
      final noticeGenerated = Noticegenerated.fromJson(response.data);

      // 각 공지사항의 content 필드에서 HTML 태그를 제거
      noticeGenerated.notices?.forEach((notice) {
        notice.content = _removeHtmlTags(notice.content);
      });

      return noticeGenerated.notices ?? [];
    } catch (e) {
      throw Exception('공지사항을 불러오는데 실패했습니다.');
    }
  }

// html 태그 제거
  String _removeHtmlTags(String? htmlText) {
    if (htmlText == null) return '';
    final RegExp regExp =
        RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlText.replaceAll(regExp, '');
  }
}
