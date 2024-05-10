 import 'package:flutter/material.dart';

/// 네비게이터를 사용하여 라우트를 이동하고, 이전 라우트를 제거
  void navigateAndRemoveUntil(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
        context, routeName, (Route<dynamic> route) => false);
  }