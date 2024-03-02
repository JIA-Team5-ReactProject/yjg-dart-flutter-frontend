import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/auth/data/data_resources/login_data_source.dart';
import 'package:yjg/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:yjg/auth/presentation/viewmodels/privilege_viewmodel.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';

class LoginUseCase {
  final WidgetRef ref;

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
    bool? isAdmin = ref.watch(isAdminProvider); // false: Student, true: Admin
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
    _navigateAndRemoveUntil(context, '/dashboard_main');
  }

  /// 관리자 권한에 따라 로그인 처리
Future<void> _loginAsAdmin(BuildContext context, String adminPrivilege) async {
  await LoginDataSource().postAdminLoginAPI(ref);

  // AdminPrivilegesNotifier에서 업데이트된 권한 상태를 가져옴
  String adminPrivilege = ref.watch(adminPrivilegesProvider);

  switch (adminPrivilege) {
    case 'salon':
      _navigateAndRemoveUntil(context, '/admin_salon_main'); // 미용실 관리자 페이지로 이동
      break;
    case 'admin':
      _navigateAndRemoveUntil(context, '/as_admin'); // AS 관리자 페이지로 이동
      break;
    default:
      _showLoginError(context); // 권한이 없거나 레스토랑 권한인 경우 로그인 에러 처리
      break;
  }
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
