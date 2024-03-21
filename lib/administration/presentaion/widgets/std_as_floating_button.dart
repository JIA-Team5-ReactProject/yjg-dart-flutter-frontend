import 'package:flutter/material.dart';

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
            child: const Icon(Icons.edit, size: 20),
            heroTag: 'editBtn',
          ),
          const SizedBox(width: 5),
          FloatingActionButton(
            onPressed: onDelete,
            child: const Icon(Icons.delete, size: 20),
            backgroundColor: Colors.red,
            heroTag: 'deleteBtn',
          ),
        ],
      ),
    );
  }
}
