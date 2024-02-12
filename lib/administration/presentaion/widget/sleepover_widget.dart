import 'package:flutter/material.dart';

class SleepoverWidget extends StatefulWidget {
  final bool apply;
  final String StartDate;
  final String LastDate;

  const SleepoverWidget(
      {Key? key,
      this.apply = false,
      this.StartDate = '0000/00/00',
      this.LastDate = '0000/00/00'})
      : super(key: key);

  @override
  State<SleepoverWidget> createState() => _SleepoverWidgetState();
}

class _SleepoverWidgetState extends State<SleepoverWidget> {
  @override
  Widget build(BuildContext context) {
    //승인중일때
    if (widget.apply == false) {
      return InkWell(
        onTap: () {
          SleepoverAlert(context,
              apply_alert: false,
              StartDate: widget.StartDate,
              LastDate: widget.LastDate);
        },
        child: Container(
          width: 380,
          height: 100,
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                blurRadius: 5.0,
                blurStyle: BlurStyle.outer,
                color: Color.fromARGB(255, 136, 136, 136))
          ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    '승인중',
                    style: TextStyle(color: Colors.red, fontSize: 25),
                  )),
              Text(
                widget.StartDate,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text('~'),
              Container(
                width: 170,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Opacity(
                        opacity: 0.4,
                        child: Image.asset(
                          'assets/img/yju_tiger_logo.png',
                          width: 80,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 37,
                      left: 3,
                      child: Text(
                        widget.LastDate,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    //승인 완료 일 때
    else {
      return InkWell(
        onTap: () {
          SleepoverAlert(context,
              apply_alert: true,
              StartDate: widget.StartDate,
              LastDate: widget.LastDate);
        },
        child: Container(
          width: 380,
          height: 100,
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                blurRadius: 5.0,
                blurStyle: BlurStyle.outer,
                color: Color.fromARGB(255, 136, 136, 136))
          ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    '승인O',
                    style: TextStyle(color: Colors.blue, fontSize: 25),
                  )),
              Text(
                widget.StartDate,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text('~'),
              Container(
                width: 170,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Opacity(
                        opacity: 0.4,
                        child: Image.asset(
                          'assets/img/yju_tiger_logo.png',
                          width: 80,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 37,
                      left: 3,
                      child: Text(
                        widget.LastDate,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<dynamic> SleepoverAlert(BuildContext context,
      {required bool apply_alert,
      required String StartDate,
      required String LastDate}) {
    //승인 완료 alert창
    if (apply_alert == true) {
      return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Container(
            alignment: Alignment.center,
            child: Text(
              '승인O',
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '$StartDate ~ $LastDate',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),

              //선
              Container(
                width: 380,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.blue),
                  ),
                ),
              ),

              //사유 글자
              Text(
                '사유',
                style: TextStyle(fontSize: 17),
              ),

              //내용물
              Container(
                alignment: Alignment.centerLeft,
                child: Text('본가 방문',style: TextStyle(fontWeight: FontWeight.normal),),
              )
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.cancel_outlined))
          ],
        ),
      );
    }

    //승인중 alert 창
    else {
      return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Container(
            alignment: Alignment.center,
            child: Text(
              '승인중',
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '$StartDate ~ $LastDate',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),

              //선
              Container(
                width: 380,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.red),
                  ),
                ),
              ),

              //사유 글자
              Text(
                '사유',
                style: TextStyle(fontSize: 17),
              ),

              //내용물
              Container(
                alignment: Alignment.centerLeft,
                child: Text('본가 방문',style: TextStyle(fontWeight: FontWeight.normal),),
              )
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.cancel_outlined))
          ],
        ),
      );
    }
    }
  }
