import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/auth/data/data_resources/reset_password_data_source.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';

class ResetPasswordNewUseCase {
  final WidgetRef ref;

  ResetPasswordNewUseCase({required this.ref});

  Future<void> execute({
    required String newPassword,
    required BuildContext context,
  }) async {
    // User 상태 업데이트를 위해 userProvider를 통해 User 인스턴스에 접근
    ref.read(userProvider.notifier).resetPasswordFormUpdate(
          newPassword: newPassword,
        );

    // 비밀번호 업데이트
    try {
      ResetPasswordDataSource dataSource = ResetPasswordDataSource();
      await dataSource.patchNewPasswordAPI(ref);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('비밀번호가 변경되었습니다. 로그인 해 주세요.'),
          backgroundColor: Palette.mainColor,
        ),
      );
      // 성공 시 로그인 페이지로 이동
      Navigator.pushNamed(context, '/login_student');
    } catch (e) {
      // 회원가입 실패 시 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('비밀번호 변경에 실패했습니다. 다시 시도해 주세요.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
