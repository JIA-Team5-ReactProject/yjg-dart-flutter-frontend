import 'package:flutter/material.dart';
import 'package:yjg/administration/data/data_sources/sleepover_data_source.dart';
import 'package:yjg/shared/theme/palette.dart';

class SleepoverWidget extends StatefulWidget {
  final int id;
  final int apply; // 0: 거절, 1: 승인
  final String startDate;
  final String lastDate;
  final String content;

  const SleepoverWidget({
    Key? key,
    required this.id,
    required this.apply,
    required this.startDate,
    required this.lastDate,
    required this.content,
  }) : super(key: key);

  @override
  State<SleepoverWidget> createState() => _SleepoverWidgetState();
}

class _SleepoverWidgetState extends State<SleepoverWidget> {
  final _sleepoverDataSource = SleepoverDataSource();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    String statusText;
    Color statusColor;

    switch (widget.apply) {
      case 0:
        statusText = "거절";
        statusColor = Palette.stateColor3;
        break;
      default:
        statusText = "승인";
        statusColor = Palette.mainColor;
    }

    return Material(
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.0),
        highlightColor: Colors.grey.withOpacity(0.0),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  widget.apply == 0 ? '거절' : '승인',
                  style: TextStyle(
                      color: widget.apply == 0
                          ? Palette.stateColor3
                          : Palette.mainColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      margin: EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: Text(
                        widget.content,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Text(
                      '신청일자  ${widget.startDate} ~ ${widget.lastDate}',
                      style: TextStyle(
                        color: Palette.textColor.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('신청 취소', style: TextStyle(color: Palette.stateColor3, fontSize: 13.0)),
                  onPressed: () async {
                    await _sleepoverDataSource.deleteApplication(widget.id);
                    // 결과를 전달하며 Navigator.pop 메서드 호출
                    Navigator.of(context).pop(); //현재 alert창 닫기
                    Navigator.of(context).pop(); //외박/외출 메인 창 닫기
                    Navigator.pushNamed(context, '/sleepover');
                  },
                ),
                TextButton(
                  child: Text('닫기', style: TextStyle(color: Palette.stateColor4, fontSize: 13.0)),
                  onPressed: () {
                    Navigator.of(context).pop(); // alert 창 닫기
                  },
                ),
              ],
            ),
          );
        },
        child: Container(
          width: screenWidth * 0.85,
          height: 100,
          padding: EdgeInsets.all(20), // 패딩 추가
          margin: EdgeInsets.symmetric(vertical: 10), // 수직 마진 추가
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // 모서리 둥글게
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 8,
                offset: Offset(0, 2), // 그림자 효과
              ),
            ],
          ),
          child: InkWell(
            child: SizedBox(
                child: Row(
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.bedtime,
                      color: statusColor,
                      size: 40,
                    ),
                    Text(
                      statusText,
                      style: TextStyle(color: statusColor, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  widget.startDate,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  ' ~ ',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  widget.lastDate,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
