import 'dart:math';
import 'package:flutter/services.dart';

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (newText.length <= 3) return TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: newText.length));
    if (newText.length <= 7) return TextEditingValue(text: '${newText.substring(0, 3)}-${newText.substring(3)}', selection: TextSelection.collapsed(offset: newText.length + 1));
    return TextEditingValue(
      text: '${newText.substring(0, 3)}-${newText.substring(3, 7)}-${newText.substring(7)}',
      selection: TextSelection.collapsed(offset: min(newText.length + 2, 13)),
    );
  }
}

