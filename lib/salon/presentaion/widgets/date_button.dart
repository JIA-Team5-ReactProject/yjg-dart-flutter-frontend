import 'package:flutter/material.dart';
import 'package:yjg/shared/theme/palette.dart';

class DateButton extends StatefulWidget {
  const DateButton({Key? key, required this.time}) : super(key: key);
  final String time;

  @override
  State<DateButton> createState() => _DateButtonState();
}

class _DateButtonState extends State<DateButton> {
  bool _isPressed = false; // 버튼이 눌렸는지 상태를 저장하는 변수

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82,
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            _isPressed = !_isPressed; // 버튼을 누를 때마다 상태를 변경
          });
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          side: MaterialStateProperty.all(
            BorderSide(color: Palette.stateColor4.withOpacity(0.7), width: 0.5),
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (_isPressed) { // _isPressed 변수에 따라 색상 변경
                return Palette.mainColor.withOpacity(0.2);
              }
              return null; // 기본 상태의 배경색
            },
          ),
        ),
        child: Text(
          widget.time,
          style: TextStyle(
            color: Palette.textColor,
            fontWeight: FontWeight.w300,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
