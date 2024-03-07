import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/data/models/business_hours.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final timeSlotsProvider = StateProvider<List<String>>((ref) {
  final selectedDate = ref.watch(selectedDateProvider.state).state;
  
  return BusinessHours(sTime: "09:00", eTime: "18:00").getTimeSlots();
});

final selectedTimeSlotProvider = StateProvider<String?>((ref) => null);
final selectedServiceIdProvider = StateProvider<int>((ref) => -1);
final selettedServiceNameProvider = StateProvider<String>((ref) => '');