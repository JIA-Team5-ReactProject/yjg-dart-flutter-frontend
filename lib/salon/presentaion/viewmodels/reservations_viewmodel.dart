import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/data/data_sources/my_booking_data_source.dart';
import 'package:yjg/salon/data/models/reservation.dart';

final myBookingDataSourceProvider = Provider((ref) => MyBookingDataSource());

final reservationsProvider = FutureProvider<List<Reservations>>((ref) async {
  final dataSource = ref.watch(myBookingDataSourceProvider);
  final response = await dataSource.getReservationAPI();
  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse =
        jsonDecode(utf8.decode(response.bodyBytes))['reservations'];

    debugPrint('예약 목록: $jsonResponse');
    return jsonResponse.map((json) => Reservations.fromJson(json)).toList();
  } else {
    throw Exception('예약 목록을 불러오지 못했습니다.');
  }
});
