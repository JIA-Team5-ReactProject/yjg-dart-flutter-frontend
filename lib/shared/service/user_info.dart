import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserInfo {
  static final storage = FlutterSecureStorage();

  static Future<Map<String, String?>> getUserInfo() async {
    String? name = await storage.read(key: 'name');
    String? studentNum = await storage.read(key: 'student_id');
    return {'name': name, 'studentNum': studentNum};
  }
}
