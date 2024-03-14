import 'package:flutter/material.dart';
import 'package:yjg/shared/theme/palette.dart';

class MainRoundedBoxSmall extends StatelessWidget {
  final IconData iconData; // 아이콘 데이터
  final String bookText;
  final String time;
  final Color iconColor; // 아이콘 색상

  const MainRoundedBoxSmall({
    super.key,
    required this.iconData,
    required this.bookText,
    required this.time,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        margin: EdgeInsets.symmetric(vertical: 7.0),
        height: 70.0,
        width: MediaQuery.of(context).size.width * 0.85,
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
            Icon(iconData, color: iconColor),
            SizedBox(width: 15),
            Text(
              bookText,
              style: TextStyle(color: Palette.textColor, fontSize: 15),
            ),
            Spacer(), // 빈 여백을 만듦
            Text(
              time,
              style: TextStyle(color: Palette.stateColor1, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
