import 'package:flutter/material.dart';
import 'package:yjg/theme/palette.dart';

class CustomRoundedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CustomRoundedButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(color: Palette.backgroundColor), // 글자 색상-흰
      ),
      style: OutlinedButton.styleFrom(
        // 버튼 사이즈 설정
        
        side: BorderSide(color: Palette.backgroundColor), // 테두리 선-흰
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // 버튼 둥글게
        ),
        backgroundColor: Colors.transparent, // 배경색 투명하게
      ),
    );
  }
}
