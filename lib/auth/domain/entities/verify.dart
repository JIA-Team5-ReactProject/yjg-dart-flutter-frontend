import 'package:flutter/material.dart';

class Verify extends ChangeNotifier {
  String verifyCode;

  Verify({required this.verifyCode});

  // 인증 코드 폼 업데이트
  void verifyCodeFormUpdate({
    String? verifyCode,
  }) {
    if (verifyCode != null) this.verifyCode = verifyCode;

    notifyListeners(); // Verify 객체가 변경되었음을 알림
  }
}
