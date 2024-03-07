import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/data/data_sources/booking_data_source.dart';
import 'package:yjg/salon/data/models/business_hours.dart';

final salonHoursProvider = FutureProvider<List<BusinessHours>>((ref) async {
  final response = await BookingDataSource().getSalonHourAPI();
  final List<dynamic> decoded = json.decode(response.body)['business_hours'];
  return decoded.map<BusinessHours>((json) => BusinessHours.fromJson(json)).toList();
});
