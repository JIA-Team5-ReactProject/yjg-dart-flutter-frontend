import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:yjg/shared/theme/palette.dart";

class AuthTextFormField extends ConsumerWidget {
  AuthTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.validatorText,
    this.inputFormatter, // 포맷터 추가
    this.suffixIcon, // suffixIcon 추가
  });

  final TextEditingController controller;
  final String labelText;
  final String validatorText;
  final TextInputFormatter? inputFormatter;
  final Widget? suffixIcon; // suffixIcon 정의

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return SizedBox(
      width: width * 0.8,
      height: height * 0.08,
      child: TextFormField(
        // 라벨텍스트에 비밀번호라는 글자가 포함되어 있으면 obscureText를 true로 설정
        obscureText: labelText.contains("login.sharedForm.password".tr()) ? true : false,
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.mainColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.stateColor4.withOpacity(0.5),),
          ),
          border: OutlineInputBorder(),
          labelText: labelText,
          labelStyle: TextStyle(color: Palette.textColor.withOpacity(0.7), fontSize: 14.0),
          suffixIcon: suffixIcon, // suffixIcon 사용
        ),
        // 유효성 검사
        // ! TextInputForm의 유효성 검사는 validator 속성을 통해 진행하는 것이 일반적이다!
        validator: (value) {
          // 공통: 필수 입력값 검사
          if (value == null || value.isEmpty) {
            return 'registration.form.validatorText.isRequiredField'.tr();
          }

          // 이메일 유효성 검사
          if (labelText == "registration.form.email".tr() &&
              !RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b').hasMatch(value)) {
            return 'registration.form.validatorText.isEmail'.tr();
          }

          // 비밀번호 유효성 검사
          if ((labelText == "login.sharedForm.password".tr() )&& value.length < 8) {
            return 'registration.form.validatorText.isPasswordMinLength'.tr();
          }
          return null;
          // 유효성 검사를 통과했다면 null 반환
        },
        inputFormatters: inputFormatter != null
            ? [inputFormatter!, LengthLimitingTextInputFormatter(13)]
            : [],
      ),
    );
  }
}
