
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/data/data_sources/booking_data_source.dart';
import 'package:yjg/salon/data/models/business_hours.dart';

import 'package:intl/intl.dart'; 

final salonHoursProvider = FutureProvider.family<List<BusinessHours>, String>((ref, date) async {
  final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(date)); // 날짜 포맷팅
  final response = await BookingDataSource().getSalonHourAPI(formattedDate);
  final List<dynamic> decoded = response.data['business_hours'];
  return decoded.map<BusinessHours>((json) => BusinessHours.fromJson(json)).toList();
});
