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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorText;
        }
        return null;
      },
      inputFormatters:
          inputFormatter != null ? [inputFormatter!] : [], 
    );
  }
}
