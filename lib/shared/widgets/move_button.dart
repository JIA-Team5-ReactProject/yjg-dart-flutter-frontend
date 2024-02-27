import 'package:flutter/material.dart';

class MoveButton extends StatelessWidget {
  final IconData icon;
  final String text1;
  final String text2;
  final String route;

  const MoveButton({
    Key? key,
    required this.icon,
    required this.text1,
    required this.text2,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      Navigator.pushNamed(context, route); // 각 버튼에 맞는 페이지로 이동
    },
    child: Container(
      width: 150,
      height: 170,
      decoration: boxStyle,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: Color.fromARGB(255, 29, 127, 159), size: 50.0), // 아이콘
          SizedBox(height: 10.0), // 아이콘과 글자 사이의 간격
          Text(
            text1,
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
          ), // 첫 번째 글자
          Text(
            text2,
            style: TextStyle(color: Colors.black, fontSize: 14),
          ), // 두 번째 글자
        ],
      ),
    ),
    );
  }
}

//이동 버튼 위젯 디자인
var boxStyle = BoxDecoration(
  boxShadow: [
    // 그림자
    BoxShadow(
      color: Colors.grey.withOpacity(0.2),
      spreadRadius: 5, // 그림자 넓이
      blurRadius: 5, // 그림자 흐림도
      offset: Offset(3, 3), // 그림자가 박스랑 얼마나 떨어져서 나타날지
    ),
  ],
  border: Border.all(color: Color.fromARGB(255, 139, 139, 139), width: 0.5),
  color: Colors.white,
  borderRadius: BorderRadius.circular(15.0),
);