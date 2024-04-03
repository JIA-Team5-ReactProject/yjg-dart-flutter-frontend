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
            content: Text('인증에 성공했습니다. 비밀번호를 재설정해 주세요.'),
            backgroundColor: Palette.mainColor),
      );
      Navigator.pushNamed(context, '/new_password');
    } catch (e) {
      // 회원가입 실패 시 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('인증번호가 올바르지 않습니다. 다시 한 번 확인해 주세요.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
