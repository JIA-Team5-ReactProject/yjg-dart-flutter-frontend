import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/auth/data/data_resources/reset_password_data_source.dart';
import 'package:yjg/auth/presentation/viewmodels/verify_code_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';

class ResetPasswordVerifyCodeUseCase {
  final WidgetRef ref;

  ResetPasswordVerifyCodeUseCase({required this.ref});

  Future<void> execute({
    required String verifyCode,
    required BuildContext context,
  }) async {
    ref.read(verifyCodeProvider.notifier).setVerifyCode(verifyCode);

    // 인증 코드 확인 로직 구현
    try {
      ResetPasswordDataSource dataSource = ResetPasswordDataSource();
      await dataSource.postResetPasswordMailVerifyAPI(ref);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('forgotPassword.form.isVerificationSuccessful').tr(),
            backgroundColor: Palette.mainColor),
      );
      Navigator.pushNamed(context, '/new_password');
    } catch (e) {
      // 회원가입 실패 시 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('forgotPassword.form.isVerificationCodeInvalid').tr(),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
