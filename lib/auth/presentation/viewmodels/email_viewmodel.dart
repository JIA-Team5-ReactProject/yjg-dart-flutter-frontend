import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/auth/data/data_resources/register_data_source.dart';

class EmailStateNotifier extends StateNotifier<bool?> {
  EmailStateNotifier() : super(null);

  Future<bool> checkEmail(String email) async {
    // API 통신을 통한 이메일 중복 검사 로직
    // 결과에 따라 상태 업데이트
    // API 통신 결과가 중복이면 true, 아니면 false
    bool isDuplicate = await RegisterDataSource().checkEmailDuplicate(email);
    state = isDuplicate; // 상태 업데이트
    return isDuplicate;
  }
}

final emailStateProvider = StateNotifierProvider<EmailStateNotifier, bool?>((ref) {
  return EmailStateNotifier();
});


class EmailCheckSuccessStateNotifier extends StateNotifier<bool> {
  EmailCheckSuccessStateNotifier() : super(false); 

  void setEmailCheckSuccessStateNotifier(bool isSuccess) {
    state = isSuccess;
  }
}

final emailCheckSuccessStateProvider = StateNotifierProvider<EmailCheckSuccessStateNotifier, bool>((ref) {
  return EmailCheckSuccessStateNotifier();
});
