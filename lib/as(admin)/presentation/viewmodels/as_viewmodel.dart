import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/as(admin)/data/data_sources/as_data_source.dart';
import 'package:yjg/as(admin)/data/models/as_list.dart';

final currentPageProvider = StateProvider<int>((ref) => 1);

final serviceIdProvider = StateProvider<int>((ref) => 0);

final asDataNotifierProvider =
    StateNotifierProvider<AsDataNotifier, AsyncValue<AfterServiceResponse>>(
        (ref) {
  return AsDataNotifier(ref);
});

class AsDataNotifier extends StateNotifier<AsyncValue<AfterServiceResponse>> {
  Ref ref;
  AsDataNotifier(this.ref) : super(AsyncValue.loading());

  // 특정 상태의 AS 데이터를 불러오는 메서드
  Future<void> fetchAsData(int status) async {
    state = AsyncValue.loading();
    try {
      final page = ref.read(currentPageProvider);
      final response = await AsDataSource().getAsDataAPI(status, page);
      final data = AfterServiceResponse.fromJson(jsonDecode(response.body));
      state = AsyncValue.data(data);
    } catch (e, s) {
      debugPrint('fetchAsData error: $e, stack trace: $s'); // 오류와 스택 트레이스 출력
      state = AsyncValue.error(e, s);
    }
  }
}
