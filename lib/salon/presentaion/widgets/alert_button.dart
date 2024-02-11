import 'package:flutter/material.dart';
import 'package:yjg/salon/presentaion/pages/salon_main.dart';
import 'package:yjg/shared/theme/palette.dart'; 

class AlertButton extends StatelessWidget {
  const AlertButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showAlert(context),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Palette.mainColor.withOpacity(0.8);
          }
          return Palette.mainColor;
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.white.withOpacity(0.8);
          }
          return Colors.white;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Palette.mainColor),
          ),
        ),
        fixedSize: MaterialStateProperty.all<Size>(Size(100, 40)),
      ),
      child: Text('예약'),
    );
  }

  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 사용자가 다이얼로그 외부를 탭해도 닫히지 않도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
         
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          titlePadding: EdgeInsets.fromLTRB(24, 24, 24, 10), 
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                // 아이콘을 감싸는 동그라미 추가
                backgroundColor: Palette.mainColor.withOpacity(0.2),
                radius: 30,
                child:
                    Icon(Icons.volume_up, size: 30, color: Palette.mainColor),
              ),
              SizedBox(height: 16), 
              Text(
                '예약 완료',
                style: TextStyle(
                  color: Palette.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            '예약이 완료되었습니다!',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
            textAlign: TextAlign.center,
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          actionsPadding: EdgeInsets.only(bottom: 20), 
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            Container(
              width: double.infinity,
              height: 50, 
              margin: EdgeInsets.symmetric(horizontal: 20), 
              decoration: BoxDecoration(
                color: Palette.mainColor.withOpacity(0.2), 
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                child: Text(
                  '확인',
                  style: TextStyle(
                    color: Palette.mainColor,
                    fontSize: 14,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SalonMain()),
                  ); 
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
