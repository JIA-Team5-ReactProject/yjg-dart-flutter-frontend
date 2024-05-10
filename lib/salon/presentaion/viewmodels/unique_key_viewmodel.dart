import 'package:flutter_riverpod/flutter_riverpod.dart';

final uniqueKeyProvider = StateProvider<String>((ref) {
  return ""; // 초기값 설정
});