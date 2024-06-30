import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage(); // 토큰 담는 곳

// 스토리지 모듈
Future<void> saveToStorage(Map<String, String> data) async {
  for (var key in data.keys) {
    await storage.write(key: key, value: data[key]);
  }
}
