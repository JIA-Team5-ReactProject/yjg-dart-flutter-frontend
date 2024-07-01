import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/auth/data/data_resources/reset_password_data_source.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';

class ResetPasswordUseCase {
  final WidgetRef ref;

  ResetPasswordUseCase({required this.ref});

  Future<void> execute({
    required String email,
    required String name,
    required BuildContext context,
  }) async {
    // User 상태 업데이트를 위해 userProvider를 통해 User 인스턴스에 접근
    ref.read(userProvider.notifier).resetPasswordUpdate(
          email: email,
          name: name,
        );

    // 회원가입 로직 구현
    try {
      ResetPasswordDataSource dataSource = ResetPasswordDataSource();
      await dataSource.postResetPasswordAPI(ref);

      // 성공 시 인증 코드 입력 페이지로 이동
      Navigator.pushNamed(context, '/mail_verification_code');
    } catch (e) {
      // 회원가입 실패 시 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('forgotPassword.form.isUserNotFound'.tr()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
