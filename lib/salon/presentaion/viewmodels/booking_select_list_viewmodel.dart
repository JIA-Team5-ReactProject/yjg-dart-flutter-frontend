import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedTimeSlotProvider = StateProvider<String?>((ref) => null);
final selectedServiceIdProvider = StateProvider<int>((ref) => -1);
final selettedServiceNameProvider = StateProvider<String>((ref) => '');