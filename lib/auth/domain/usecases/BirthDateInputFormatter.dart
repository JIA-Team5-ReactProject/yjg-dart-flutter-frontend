import 'dart:math';
import 'package:flutter/services.dart';

class BirthDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (newText.length <= 4) return TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: newText.length));
    if (newText.length <= 6) return TextEditingValue(text: '${newText.substring(0, 4)}-${newText.substring(4)}', selection: TextSelection.collapsed(offset: newText.length + 1));
    return TextEditingValue(
      text: '${newText.substring(0, 4)}-${newText.substring(4, 6)}-${newText.substring(6)}',
      selection: TextSelection.collapsed(offset: min(newText.length + 2, 10)),
    );
  }
}