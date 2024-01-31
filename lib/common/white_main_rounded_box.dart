import 'package:flutter/material.dart';
import 'package:yjg/theme/palette.dart';

class WhiteMainRoundedBox extends StatelessWidget {
  final IconData iconData; // 아이콘 데이터
  final String mainText; // 주요 텍스트
  final String secondaryText; // 보조 텍스트
  final String actionText; // 액션 텍스트
  final String timeText; // 시간 텍스트

  const WhiteMainRoundedBox({
    super.key,
    required this.iconData,
    required this.mainText,
    required this.secondaryText,
    required this.actionText,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Palette.stateColor4.withOpacity(0.5),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Palette.mainColor.withOpacity(0.1),
            radius: 30.0, 
            child: Icon(
              iconData,
              color: Palette.mainColor.withOpacity(0.7),
              size: 30.0,
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  mainText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Palette.textColor,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 3.0), // 텍스트 간격 조절
                Text(
                  secondaryText,
                  style: TextStyle(
                    color: Palette.stateColor4,
                  ),
                ),
                SizedBox(height: 5.0), // 텍스트 간격 조절
                Text(
                  actionText,
                  style: TextStyle(
                    color: Palette.stateColor3,
                    fontSize: 12.0
                  ),
                ),
              ],
            ),
          ),
          Text(
            timeText,
            style: TextStyle(
              color: Palette.mainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
