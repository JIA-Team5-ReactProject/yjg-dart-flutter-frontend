import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:yjg/shared/theme/palette.dart";

class AuthTextFormField extends StatelessWidget {
  const AuthTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.validatorText,
    this.inputFormatter, // 포맷터 추가
  });

  final TextEditingController controller;
  final String labelText;
  final String validatorText;
  final TextInputFormatter? inputFormatter;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: labelText == "비밀번호" ? true : false,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Palette.mainColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Palette.stateColor4),
        ),
        border: OutlineInputBorder(),
        labelText: labelText,
        labelStyle: TextStyle(color: Palette.textColor, fontSize: 14.0),
      ),
      // 유효성 검사
      // ! TextInputForm의 유효성 검사는 validator 속성을 통해 진행하는 것이 일반적이다!
      validator: (value) {
        // 공통: 필수 입력값 검사
        if (value == null || value.isEmpty) {
          return '필수 입력 항목입니다.';
        }

        // 이메일 유효성 검사
        if (labelText == "이메일" &&
            !RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b').hasMatch(value)) {
          return '유효한 이메일 주소를 입력해주세요.';
        }

        // 비밀번호 유효성 검사
        if (labelText == "비밀번호" && value.length < 8) {
          return '비밀번호는 최소 8자 이상이어야 합니다.';
        }

        return null; // 유효성 검사를 통과했다면 null 반환
      },
      inputFormatters: inputFormatter != null ? [inputFormatter!] : [],
    );
  }
}
