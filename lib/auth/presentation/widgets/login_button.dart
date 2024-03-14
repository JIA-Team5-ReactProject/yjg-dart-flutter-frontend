import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/auth/domain/usecases/login_usecase.dart';
import 'package:yjg/shared/theme/palette.dart';

class LoginButton extends ConsumerWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  static final storage = FlutterSecureStorage();

  LoginButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? currentRouteName = ModalRoute.of(context)?.settings.name;
    return ElevatedButton(
      onPressed: () async {
        if (emailController.text.isNotEmpty &&
            passwordController.text.isNotEmpty) {

          // 현재 라우트가 '/login_student'인 경우 isAdminProvider의 상태를 false로 설정(라우터에 따른 API 통신 변경)
          currentRouteName == '/login_student'
              ? storage.write(key: 'isAdmin', value: 'false') 
              : storage.write(key: 'isAdmin', value: 'true'); 

          debugPrint('유형: ${await storage.read(key: 'isAdmin')}, 현재 라우트: $currentRouteName');
          // LoginUseCase 인스턴스 생성
          final loginUseCase =
              LoginUseCase(ref: ref);

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
