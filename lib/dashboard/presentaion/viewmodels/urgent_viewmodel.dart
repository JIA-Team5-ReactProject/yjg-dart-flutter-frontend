import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/dashboard/data/data_sources/urgent_data_source.dart';
import 'dart:convert';

import 'package:yjg/dashboard/data/models/urgent.dart';


// API 호출
Future<Notice> fetchUrgentNotice() async {
  final response = await UrgentDataSource().getUrgentApi();
  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return Notice.fromJson(data);
  } else {
    throw Exception('Failed to load notice');
  }
}

// Notice 상태 관리
final urgentNoticeProvider = FutureProvider<Notice>((ref) async {
  return fetchUrgentNotice();
});
