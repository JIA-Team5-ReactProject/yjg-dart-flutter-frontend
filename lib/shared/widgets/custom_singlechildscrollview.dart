import 'package:flutter/material.dart';

class CustomSingleChildScrollView extends StatelessWidget {
  final Widget child;

  const CustomSingleChildScrollView({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(), // 사용자가 스크롤을 안 한 상태(가장 상단)에 있을 때 스크롤을 막아준다
      child: child,
    );
  }
}


