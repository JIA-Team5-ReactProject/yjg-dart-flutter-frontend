import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/auth/data/data_resources/logout_data_source.dart';

class LogoutService {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> logout(BuildContext context, WidgetRef ref) async {
    LogoutDataSource().postLogoutAPI(ref);
    Navigator.pushNamedAndRemoveUntil(context, '/login_student', (route) => false);
  }

  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'auth_token');
    return token != null;
  }
}
