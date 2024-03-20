import 'package:flutter/material.dart';

class NoticeBox extends StatelessWidget {
  final String title; // 공지사항 제목
  final String content; // 공지사항 내용

  const NoticeBox({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            content,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
