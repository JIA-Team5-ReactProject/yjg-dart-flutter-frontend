import "package:flutter/material.dart";
import 'package:yjg/theme/palette.dart';

class BlueMainRoundedBox extends StatelessWidget {
  const BlueMainRoundedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // 상자의 너비
      height: 100, // 상자의 높이
      decoration: BoxDecoration(
        color: Palette.mainColor, // 상자의 색상
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0), // 왼쪽 아래 모서리 둥글기
          bottomRight: Radius.circular(10.0), // 오른쪽 아래 모서리 둥글기
        ),
      ),
    );
  }
}