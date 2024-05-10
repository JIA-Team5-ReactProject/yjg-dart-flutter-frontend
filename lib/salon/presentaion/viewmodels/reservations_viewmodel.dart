import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/data/data_sources/my_booking_data_source.dart';
import 'package:yjg/salon/data/models/reservation.dart';

final myBookingDataSourceProvider = Provider((ref) => MyBookingDataSource());

// autoDispose를 사용하여, 페이지를 벗어날 때 자동으로 상태를 해제
final reservationsProvider = FutureProvider.autoDispose<List<Reservations>>((ref) async {
  final dataSource = ref.watch(myBookingDataSourceProvider);
  final response = await dataSource.getReservationAPI();
  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = response.data['reservations'];
    return jsonResponse.map((json) => Reservations.fromJson(json)).toList();
  } else {
    debugPrint('예약 목록 불러오기 실패: ${response.statusCode}');
    throw Exception('예약 목록을 불러오지 못했습니다.');
  }
});
