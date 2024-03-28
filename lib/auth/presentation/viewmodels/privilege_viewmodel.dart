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



// isAdmin 상태를 관리하는 프로바이더
class IsAdminNotifier extends StateNotifier<bool> {
  IsAdminNotifier() : super(false); // 초기값은 false

  void checkAdmin(User user) {
    // 권한 리스트를 순회하면서 admin 권한이 있는지 확인
    for (final privilege in user.privileges ?? []) {
      if (privilege.privilege == 'admin') {
        state = true; // 관리자 권한 발견
        return;
      }
    }
    state = false; // 관리자 권한이 없음
  }
}

final isAdminProvider = StateNotifierProvider<IsAdminNotifier, bool>((ref) {
  return IsAdminNotifier();
});


