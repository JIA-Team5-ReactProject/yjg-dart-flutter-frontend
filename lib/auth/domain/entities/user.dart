import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  String email;
  String password;
  String name;
  String phoneNumber;

  User({
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
  });

  void loginFormUpdate({
    String? email,
    String? password,
  }) {
    if (email != null) this.email = email;
    if (password != null) this.password = password;

    notifyListeners();
  }
  
  void registerFormUpdate({
    String? email,
    String? password,
    String? name,
    String? phoneNumber,
  }) {
    if (email != null) this.email = email;
    if (password != null) this.password = password;
    if (name != null) this.name = name;
    if (phoneNumber != null) this.phoneNumber = phoneNumber;

    notifyListeners();
  }
}