import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/auth/domain/usecases/login_usecase.dart';
import 'package:yjg/shared/theme/palette.dart';

class LoginButton extends ConsumerWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
          // Form이 유효한 경우에만 회원가입 로직 실행
          final loginUseCase =
              LoginUseCase(ref: ref); // RegisterUseCase 인스턴스 생성

          // execute 메소드를 비동기적으로 호출하고, 사용자 입력을 전달
          await loginUseCase.execute(
            email: emailController.text,
            password: passwordController.text,
            context: context,
          );
        } else {
          // Form이 유효하지 않은 경우, 사용자에게 알림
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('입력되지 않은 필드가 있습니다. 다시 한 번 확인해 주세요.'),
              backgroundColor: Palette.mainColor,
            ),
          );
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Palette.mainColor.withOpacity(0.8);
          }
          return Palette.mainColor;
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.white.withOpacity(0.8);
          }
          return Colors.white;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Palette.mainColor),
          ),
        ),
      ),
      child: const Text(
        '로그인',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
