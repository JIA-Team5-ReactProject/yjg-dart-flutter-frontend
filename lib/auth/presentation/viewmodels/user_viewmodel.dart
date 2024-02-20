import 'package:flutter/material.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:yjg/auth/data/data_resources/login_data_source.dart';
import 'package:yjg/auth/domain/entities/user.dart';
import 'package:yjg/shared/theme/palette.dart';

// User 상태 업데이트를 위한 UserProvider
final userProvider = ChangeNotifierProvider<User>((ref) {
  return User(
    email: "email",
    password: "password",
    name: "name",
    phoneNumber: "phoneNumber",
  );
});
