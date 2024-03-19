import "package:flutter/material.dart";
import "package:yjg/shared/theme/palette.dart";

class EmptyBookings extends StatelessWidget {
  const EmptyBookings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment(-0.85, 0.2),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(Icons.error_outline, size: 50, color: Palette.stateColor4),
            SizedBox(height: 20.0,),
            Text(
              '예약 내역이 없습니다.',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, ),
            ),
          ],
        ),
      ),
    );
  }
}
