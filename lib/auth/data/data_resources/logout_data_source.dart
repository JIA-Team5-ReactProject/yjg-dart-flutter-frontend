import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:yjg/shared/constants/api_url.dart';

class LogoutDataSource {
  String getApiUrl() {
    // 상수 파일에서 가져온 apiURL 사용
    return apiURL;
  }

  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  // 로그아웃
  Future<void> postLogoutAPI(WidgetRef ref) async {
    bool? isAdmin = ref.watch(isAdminProvider); // false: Student, true: Admin
    debugPrint('isAdmin: $isAdmin');
    final token = await storage.read(key: 'auth_token');
    final String url;
    isAdmin == true
        ? url = '$apiURL/api/admin/logout'
        : url = '$apiURL/api/user/logout';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      await storage.delete(key: 'auth_token');
      await storage.delete(key: 'refresh_token');
      await storage.delete(key: 'studentName');
      debugPrint('로그아웃 완료');
    }
  }
}
