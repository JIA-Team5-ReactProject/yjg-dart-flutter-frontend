import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/auth/data/data_resources/login_data_source.dart';
import 'package:yjg/auth/presentation/viewmodels/privilege_viewmodel.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';

class LoginUseCase {
  final WidgetRef ref;
  final storage = FlutterSecureStorage();

  LoginUseCase({required this.ref});

  Future<void> execute({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    // 로그인 폼 업데이트
    ref.read(userProvider.notifier).registerFormUpdate(
          email: email,
          password: password,
        );

    // 로그인 상태 업데이트
     // false: Student, true: Admin
    String adminPrivilege = ref.watch(adminPrivilegesProvider);
    bool? isAdmin = await storage.read(key: 'isAdmin') == 'true' ? true : false;

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
    _navigateAndRemoveUntil(context, '/dashboard_main');
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
    _navigateAndRemoveUntil(context, route);
  }

  /// 네비게이터를 사용하여 라우트를 이동하고, 이전 라우트를 제거
  void _navigateAndRemoveUntil(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
        context, routeName, (Route<dynamic> route) => false);
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
