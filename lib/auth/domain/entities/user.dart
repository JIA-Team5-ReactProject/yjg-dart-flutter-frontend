import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  String email;
  String password;
  String name;
  String phoneNumber;
  String displayName;
  String studentId;
  String idToken;

  User(
      {required this.email,
      required this.password,
      required this.name,
      required this.phoneNumber,
      required this.displayName,
      required this.studentId,
      required this.idToken});

  // 로그인 폼 업데이트
  void loginFormUpdate({
    String? email,
    String? password,
  }) {
    if (email != null) this.email = email;
    if (password != null) this.password = password;

    notifyListeners(); // User 객체가 변경되었음을 알림
  }

  // 회원가입, 로그인 폼 업데이트
  void registerFormUpdate({
    String? email,
    String? password,
    String? name,
    String? phoneNumber,
    String? studentId,
  }) {
    if (email != null) this.email = email;
    if (password != null) this.password = password;
    if (name != null) this.name = name;
    if (phoneNumber != null) this.phoneNumber = phoneNumber;
    if (studentId != null) this.studentId = studentId;
 
    notifyListeners(); // User 객체가 변경되었음을 알림
  }

  // 추가 정보 입력 폼 업데이트
  void additionalInfoFormUpdate({
    String? studentId,
    String? name,
    String? phoneNumber,
  }) {
    if (studentId != null) this.studentId = studentId;
    if (name != null) this.name = name;
    if (phoneNumber != null) this.phoneNumber = phoneNumber;

    notifyListeners(); // User 객체가 변경되었음을 알림
  }

  // 구글 로그인 폼 업데이트
  void updateWithGoogleSignIn({
    String? email,
    String? displayName,
    String? idToken,
  }) {
    if (email != null) this.email = email;
    if (displayName != null) this.displayName = displayName;
    if (idToken != null) this.idToken = idToken;

    notifyListeners(); // User 객체가 변경되었음을 알림
  }
}
