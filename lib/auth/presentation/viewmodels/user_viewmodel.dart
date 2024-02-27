import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:yjg/auth/domain/entities/user.dart';

// User 상태 업데이트를 위한 UserProvider
final userProvider = ChangeNotifierProvider<User>((ref) {
  return User(
    email: "email",
    password: "password",
    name: "name",
    phoneNumber: "phoneNumber",
    displayName: "displayName",
    studentId: "studentId",
  );
});


// user id 상태 업데이트를 위한 UserIdProvider
class UserIdNotifier extends StateNotifier<int> {
  UserIdNotifier() : super(0); // 초기값은 0

  void setUserId(int newUserId) {
    state = newUserId;
  }
}

final userIdProvider = StateNotifierProvider<UserIdNotifier, int>((ref) {
  return UserIdNotifier();
});
