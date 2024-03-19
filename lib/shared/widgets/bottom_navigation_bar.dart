import 'package:flutter/material.dart';
import 'package:yjg/shared/theme/palette.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '',
        ),
      ],
      unselectedItemColor: Colors.grey,
      selectedItemColor: Palette.mainColor,
      onTap: (int index) {
        switch (index) {
          case 0:
            // 현재 열려있는 창 다 닫고 홈(첫번째 페이지)으로 이동
            Navigator.of(context).popUntil((route) => route.isFirst);
            break;
          case 1:
            // 설정으로 이동하는 네비게이션
            
            break;
        }
      },
    );
  }
}