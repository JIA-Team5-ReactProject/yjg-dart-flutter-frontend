import 'package:flutter/material.dart';
import 'package:yjg/theme/pallete.dart';

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
      selectedItemColor: Pallete.mainColor
    );
  }
}