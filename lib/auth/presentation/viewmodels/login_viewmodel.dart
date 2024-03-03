import 'package:flutter_riverpod/flutter_riverpod.dart';

// isAdmin 상태 업데이트를 위한 UserIdProvider
class IsAdminNotifier extends StateNotifier<bool?> {
  IsAdminNotifier() : super(null); // 초기값 null

  void setIsAdminState(bool isAdmin) {
    state = isAdmin;
  }
}

final isAdminProvider = StateNotifierProvider<IsAdminNotifier, bool?>((ref) {
  return IsAdminNotifier();
});