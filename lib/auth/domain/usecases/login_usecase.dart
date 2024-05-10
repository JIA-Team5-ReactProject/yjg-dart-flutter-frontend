import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/auth/data/data_resources/login_data_source.dart';
import 'package:yjg/auth/presentation/viewmodels/privilege_viewmodel.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/service/navigate_and_remove_until.dart';

class LoginUseCase {
  final WidgetRef ref;
  final storage = FlutterSecureStorage();

  LoginUseCase({required this.ref});

  Future<void> execute({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    bool? isAdmin = ref.watch(isAdminProvider);
    await storage.write(key: 'isAdmin', value: isAdmin.toString());

    // 로그인 폼 업데이트
    ref.read(userProvider.notifier).registerFormUpdate(
          email: email,
          password: password,
        );

    // 로그인 상태 업데이트
    // false: Student, true: Admin
    String adminPrivilege = ref.watch(adminPrivilegesProvider);

    try {
      if (isAdmin == false) {
        // Student login
        await _loginAsStudent(context);
      } else {
        // Admin login
        await _loginAsAdmin(context, adminPrivilege);
      }
    } catch (e) {
      _showLoginError(context);
    }
  }

  /// 학생 권한에 따라 로그인 처리
  Future<void> _loginAsStudent(BuildContext context) async {
    await LoginDataSource().postStudentLoginAPI(ref);
    await storage.write(key: 'userType', value: 'student'); // 사용자 유형 저장
    navigateAndRemoveUntil(context, '/dashboard_main');
  }

  /// 관리자 권한에 따라 로그인 처리
  Future<void> _loginAsAdmin(
      BuildContext context, String adminPrivilege) async {
    await LoginDataSource().postAdminLoginAPI(ref);

    String adminPrivilege = ref.read(adminPrivilegesProvider);
    String route;
    switch (adminPrivilege) {
      case 'salon':
        route = '/admin_salon_main';
        await storage.write(key: 'userType', value: 'salon'); // 사용자 유형 저장
        break;
      case 'admin':
        route = '/as_admin';
        await storage.write(key: 'userType', value: 'admin'); // 사용자 유형 저장
        break;
      default:
        _showNoPrivilegeError(context);
        return;
    }
    navigateAndRemoveUntil(context, route);
  }



  /// 로그인 실패 시 에러 메시지를 표시
  void _showLoginError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('로그인에 실패하였습니다. 다시 시도해 주세요.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// 권한이 없는 경우 에러 메시지를 표시
  void _showNoPrivilegeError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('권한이 없습니다. 관리자에게 문의해 주세요.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
