import "package:flutter/material.dart";
import "package:yjg/shared/theme/theme.dart";

class ServiceRequester extends StatelessWidget {
  final String requester = '김*원';
  final String serviceLocation = '글로벌생활관 B동 101호';
  final List<int> stateNum = [1, 2, 3];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(
          children: [
            SizedBox(height: 15.0),
            Row(
              children: [
                Text(
                  '신청',
                  style: TextStyle(
                    color: Palette.textColor.withOpacity(0.6),
                  ),
                ),
                SizedBox(width: 50.0), // SizedBox로 간격을 줄 수 있음
                Text(requester),
              ],
            ),
            Row(
              children: [
                Text(
                  '위치',
                  style: TextStyle(
                    color: Palette.textColor.withOpacity(0.6),
                  ),
                ),
                SizedBox(width: 50.0),
                Text(serviceLocation),
              ],
            ),
            Row(
              children: [
                Text(
                  '상태',
                  style: TextStyle(
                    color: Palette.textColor.withOpacity(0.6),
                  ),
                ),
                SizedBox(width: 50.0),
                Text(
                  stateNum[0] == 1
                      ? '접수됨'
                      : stateNum[0] == 2
                          ? '진행중'
                          : '완료됨',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    color: stateNum[0] == 1
                        ? Palette.stateColor2
                        : stateNum[0] == 2
                            ? Palette.stateColor1
                            : Palette.stateColor4,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }
}
