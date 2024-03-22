import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:yjg/auth/domain/entities/user.dart';

// User 상태 업데이트를 위한 UserProvider
final userProvider = ChangeNotifierProvider<User>((ref) {
  return User(
    email: "email",
    password: "password",
    newPassword: "newPassword",
    name: "name",
    phoneNumber: "phoneNumber",
    displayName: "displayName",
    studentId: "studentId",
    idToken: "idToken",
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


// admin_id 상태 업데이트를 위한 AdminIdProvider
class AdminIdNotifier extends StateNotifier<int> {
  AdminIdNotifier() : super(0); // 초기값은 0

  void setAdminId(int newAdminId) {
    state = newAdminId;
  }
}

final adminIdProvider = StateNotifierProvider<AdminIdNotifier, int>((ref) {
  return AdminIdNotifier();
});


// 학생 이름 상태 업데이트를 위한 StudentNameProvider
class StudentNameNotifier extends StateNotifier<String> {
  StudentNameNotifier() : super(''); // 초기값은 빈 문자열

  void setStudentName(String newStudentName) {
    state = newStudentName;
  }
}

final studentNameProvider = StateNotifierProvider<StudentNameNotifier, String>((ref) {
  return StudentNameNotifier();
});