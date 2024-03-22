import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/auth/data/models/admin_service.dart';

class AdminPrivilegesNotifier extends StateNotifier<String> {
  AdminPrivilegesNotifier() : super('unauthorized'); // 기본 상태를 'unauthorized'로 설정

  void updatePrivileges(User admin) {
    // 모든 권한이 0인 경우를 먼저 체크
    if (admin.salonPrivilege == 0 && admin.adminPrivilege == 0) {
      state = 'unauthorized';
    } else if (admin.salonPrivilege == 1) {
      state = 'salon'; // 미용실 관리자 권한
    } else if (admin.adminPrivilege == 1) {
      state = 'admin'; // AS 관리자 권한
    }
  }
}


final adminPrivilegesProvider = StateNotifierProvider<AdminPrivilegesNotifier, String>((ref) {
  return AdminPrivilegesNotifier();
});


// isAdmin 상태를 관리하는 프로바이더
class IsAdminNotifier extends StateNotifier<bool?> {
  IsAdminNotifier() : super(null); // 초기값은 빈 문자열

  void setStudentName(bool isAdmin) {
    state = isAdmin;
  }
}

final isAdminProvider = StateNotifierProvider<IsAdminNotifier, bool?>((ref) {
  return IsAdminNotifier();
});

