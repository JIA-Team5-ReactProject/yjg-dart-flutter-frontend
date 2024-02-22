import "package:flutter/material.dart";
import "package:yjg/shared/theme/palette.dart";

class AsNoticeBox extends StatelessWidget {
  const AsNoticeBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.0,
      width: MediaQuery.of(context).size.width * 0.90,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.02),
          border: Border.all(
            color: Palette.stateColor4.withOpacity(0.2),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          children: [
            SizedBox(width: 10.0),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.red.withOpacity(0.2),
              child: Icon(
                Icons.priority_high,
                color: Colors.red,
              ),
            ),
            SizedBox(width: 15.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('아래 개인 정보는 기사님에게만 공개됩니다.'),
                Text(
                  '학생 정보가 유출되지 않도록 주의해주세요.',
                  style: TextStyle(
                      color: Palette.stateColor3, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
