import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/data/data_sources/notice_data_source.dart';
import 'package:yjg/salon/data/models/notice.dart';

final noticeProvider = FutureProvider.autoDispose<List<Notices>>((ref) async {
  final dataSource = NoticeDataSource();
  return await dataSource.getNoticeAPI();
});
