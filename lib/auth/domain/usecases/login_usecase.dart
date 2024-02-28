import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/auth/data/data_resources/login_data_source.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';

class LoginUseCase {
  final WidgetRef ref;

  LoginUseCase({required this.ref});

  Future<void> execute({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    // User 상태 업데이트를 위해 userProvider를 통해 User 인스턴스에 접근
    ref.read(userProvider.notifier).registerFormUpdate(
          email: email,
          password: password,
        );

    // 로그인 로직 구현
    try {
      await LoginDataSource().postLoginAPI(ref);
      // 성공 시 메인 페이지로 이동(로그인 페이지로 못 가게 막아버림)
      Navigator.pushNamedAndRemoveUntil(context, '/as_admin', (Route<dynamic> route) => false);
    } catch (e) {
      // 로그인 실패 시 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인에 실패하였습니다. 다시 시도해 주세요.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
