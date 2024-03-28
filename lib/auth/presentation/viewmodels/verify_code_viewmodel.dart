import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyCodeNotifier extends StateNotifier<String?> {
  VerifyCodeNotifier() : super(null); // 초기값은 0

  void setVerifyCode(String newVerifyCode) {
    state = newVerifyCode;
  }
}

final verifyCodeProvider = StateNotifierProvider<VerifyCodeNotifier, String?>((ref) {
  return VerifyCodeNotifier();
});
