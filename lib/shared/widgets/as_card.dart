import 'package:flutter/material.dart';
import 'package:yjg/shared/theme/palette.dart';

class AsCard extends StatefulWidget {
  final int state; //AS진행 상태
  final String title; // 제목
  final String day; // 진행 상태에 따른 날짜

  const AsCard(
      {super.key, required this.state, required this.title, required this.day});

  @override
  State<AsCard> createState() => _AsCardState();
}

class _AsCardState extends State<AsCard> {
  //내용 변수 db추가 후 삭제 해야함
  String abc = '거실등이 고장 났어요 살려주세요';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        height: 85.0,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: BorderSide(
              color: Palette.stateColor4.withOpacity(0.5),
              width: 1.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/as_detail');
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.handyman_outlined,
                color: widget.state == 1
                    ? Palette.mainColor
                    : widget.state == 2
                        ? Palette.stateColor2
                        : Palette.stateColor3,
                size: 35.0,
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Palette.textColor,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 3.0), // 텍스트 간격 조절
                    Text(
                      widget.day,
                      style: TextStyle(
                        color: Palette.stateColor4,
                      ),
                    ),
                    SizedBox(height: 5.0), // 텍스트 간격 조절
                  ],
                ),
              ),
              Text(
                widget.state == 1
                    ? '처리완료'
                    : widget.state == 2
                        ? '처리중'
                        : '미처리',
                style: TextStyle(
                  color: widget.state == 1
                      ? Palette.mainColor
                      : widget.state == 2
                          ? Palette.stateColor2
                          : Palette.stateColor3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
