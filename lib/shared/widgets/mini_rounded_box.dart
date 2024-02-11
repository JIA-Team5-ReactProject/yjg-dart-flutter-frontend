import 'package:flutter/material.dart';
import 'package:yjg/shared/theme/palette.dart';

class MiniRoundedBox extends StatelessWidget {
  final IconData iconData; // 아이콘 데이터
  final String text; // 텍스트
  final Color iconColor; // 아이콘 색상

  const MiniRoundedBox({
    super.key,
    required this.iconData,
    required this.text,
    required this.iconColor, 
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        height: 70.0,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Palette.backgroundColor,
          borderRadius: BorderRadius.circular(10.0), 
          border: Border.all(
            color: Colors.grey.shade300, 
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(iconData, color: iconColor), // 아이콘 색상을 매개변수에서 받아 사용
            SizedBox(width: 15),
            Text(text, style: TextStyle(color: Palette.textColor, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
