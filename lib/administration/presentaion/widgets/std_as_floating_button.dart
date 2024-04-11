import 'package:flutter/material.dart';
import 'package:yjg/shared/theme/palette.dart';

class StudentAsFloatingButton extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StudentAsFloatingButton({
    Key? key,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0), // 하단 간격
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
        children: [
          FloatingActionButton(
            onPressed: onEdit,
            backgroundColor: Palette.mainColor,
            heroTag: 'editBtn',
            child: const Icon(Icons.edit, size: 20,color: Colors.white),
          ),
          const SizedBox(width: 5),
          FloatingActionButton(
            onPressed: onDelete,
            backgroundColor: const Color.fromARGB(255, 166, 166, 166),
            heroTag: 'deleteBtn',
            child: const Icon(Icons.delete, size: 20,color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ],
      ),
    );
  }
}
