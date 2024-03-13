import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> logout(BuildContext context) async {
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'refresh_token');
    await storage.delete(key: 'studentName');
    debugPrint('로그아웃 완료');
    Navigator.pushNamedAndRemoveUntil(context, '/login_student', (route) => false);
  }

  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'auth_token');
    return token != null;
  }
}
