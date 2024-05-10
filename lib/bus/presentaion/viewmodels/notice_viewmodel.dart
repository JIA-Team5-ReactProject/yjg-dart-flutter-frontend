import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/bus/data/data_sources/bus_notice_data_source.dart';
import 'package:yjg/salon/data/models/notice.dart';

final noticeProvider = FutureProvider.autoDispose<List<Notices>>((ref) async {
  final dataSource = BusNoticeDataSource();
  return await dataSource.getNoticeAPI();
});
