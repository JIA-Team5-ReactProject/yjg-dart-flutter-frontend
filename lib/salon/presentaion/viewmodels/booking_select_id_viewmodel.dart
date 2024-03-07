import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalonCategoryNotifier extends StateNotifier<int?> {
  SalonCategoryNotifier() : super(null); 

  void setSalonCategoryId(int? id) {
    state = id;
  }
}

final salonCategoryProvider = StateNotifierProvider<SalonCategoryNotifier, int?>((ref) {
  return SalonCategoryNotifier();
});
