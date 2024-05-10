import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/auth/data/data_resources/register_data_source.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/theme/theme.dart';

class RegisterUseCase {
  final WidgetRef ref;

  RegisterUseCase({required this.ref});

  Future<void> execute({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String studentId,
    required BuildContext context,
  }) async {
    // User 상태 업데이트를 위해 userProvider를 통해 User 인스턴스에 접근
    ref.read(userProvider.notifier).registerFormUpdate(
          email: email,
          password: password,
          name: name,
          phoneNumber: phoneNumber,
          studentId: studentId,
        );

    // 회원가입 로직 구현
    try {
      await RegisterDataSource().postRegisterAPI(ref);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('회원가입에 성공하였습니다.'),
            backgroundColor: Palette.mainColor),
      );
      // 성공 시 로그인 페이지로 이동(이전 페이지로 못 가게 막아버림)
      Navigator.pushNamedAndRemoveUntil(
          context, '/login_student', (Route<dynamic> route) => false);
    } catch (e) {
      String message = e.toString();
      if (message.startsWith('Exception: ')) {
        message = message.substring('Exception: '.length);
      }
      // 회원가입 실패 시 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (newText.length <= 3)
      return TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length));
    if (newText.length <= 7)
      return TextEditingValue(
          text: '${newText.substring(0, 3)}-${newText.substring(3)}',
          selection: TextSelection.collapsed(offset: newText.length + 1));
    return TextEditingValue(
      text:
          '${newText.substring(0, 3)}-${newText.substring(3, 7)}-${newText.substring(7)}',
      selection: TextSelection.collapsed(offset: min(newText.length + 2, 13)),
    );
  }
}
