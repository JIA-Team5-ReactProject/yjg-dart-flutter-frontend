import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user.dart';

class AdminPrivilegesNotifier extends StateNotifier<String> {
  AdminPrivilegesNotifier() : super('unauthorized');

  void updatePrivileges(User user) {
    bool isUnauthorized = true;

    // 권한 리스트를 순회하면서 권한 체크
    for (final privilege in user.privileges ?? []) {
      if (privilege.privilege == 'salon') {
        state = 'salon';
        isUnauthorized = false;
        break; // 미용실 관리자 권한
      } else if (privilege.privilege == 'admin') {
        state = 'admin';
        isUnauthorized = false;
        break; // AS 관리자 권한
      }
    }

    if (isUnauthorized) {
      state = 'unauthorized'; // 권한이 없는 경우
    }
  }
}

final adminPrivilegesProvider = StateNotifierProvider<AdminPrivilegesNotifier, String>((ref) {
  return AdminPrivilegesNotifier();
});

final isAdminProvider = StateProvider<bool?>((ref) => null);


