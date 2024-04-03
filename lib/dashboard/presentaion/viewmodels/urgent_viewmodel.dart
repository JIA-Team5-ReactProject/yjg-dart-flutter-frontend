import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/dashboard/data/data_sources/urgent_data_source.dart';
import 'package:yjg/dashboard/data/models/urgent.dart';


// API 호출
Future<Notice> fetchUrgentNotice() async {
  final response = await UrgentDataSource().getUrgentApi();
  if (response.statusCode == 200) {
    final data = response.data;
    return Notice.fromJson(data);
  } else {
    throw Exception('공지사항을 불러오지 못했습니다.');
  }
}

// Notice 상태 관리
final urgentNoticeProvider = FutureProvider<Notice>((ref) async {
  return fetchUrgentNotice();
});
