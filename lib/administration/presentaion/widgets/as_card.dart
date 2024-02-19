import 'package:flutter/material.dart';

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
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  //제목 글자
                  Text(
                    widget.title,
                    style: TextStyle(color: Colors.black),
                  ),
                  //날짜
                  Container(
                      margin: EdgeInsets.only(left: 5, top: 5),
                      child: Text(
                        widget.day,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      )),
                  if (widget.state == 1)
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      child: Text(
                        '처리완료',
                        style: TextStyle(color: Colors.blue, fontSize: 17),
                      ),
                    )
                  else if (widget.state == 2)
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      child: Text(
                        '처리중',
                        style: TextStyle(color: Colors.orange, fontSize: 17),
                      ),
                    )
                  else
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      child: Text(
                        '미처리',
                        style: TextStyle(color: Colors.red, fontSize: 17),
                      ),
                    )
                ],
              ),
              content: SingleChildScrollView(
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color.fromARGB(255, 188, 188, 188)),
                      borderRadius: BorderRadius.circular(5)),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Text('$abc'),
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "정말로 취소하시겠습니까?",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text("예",style: TextStyle(color: Colors.black),),
                              onPressed: () {
                                Navigator.popAndPushNamed(context, '/as_page');
                              },
                            ),
                            TextButton(
                              child: Text("아니요",style: TextStyle(color: Colors.black),),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    '신청취소',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  child: Text('확인',style: TextStyle(color: Colors.black),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.all(5),
        width: 370,
        height: 70,
        decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(255, 160, 158, 188)),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            //상태에 따라 색깔이 다른 아이콘
            Container(
              margin: EdgeInsets.all(10),
              child: Icon(
                Icons.build_circle_outlined,
                color: widget.state == 1
                    ? Colors.blue
                    : widget.state == 2
                        ? Colors.orange
                        : Colors.red,
                size: 50,
              ),
            ),

            //제목,날짜
            Container(
              margin: EdgeInsets.only(top: 10, left: 10),
              child: Column(
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(widget.day, style: TextStyle(fontSize: 13)),
                ],
              ),
            ),

            //상태에 따라 색깔이랑 글이 다른 처리 진행도
            if (widget.state == 1)
              Container(
                margin: EdgeInsets.only(left: 140),
                child: Text(
                  '처리완료',
                  style: TextStyle(color: Colors.blue, fontSize: 17),
                ),
              )
            else if (widget.state == 2)
              Container(
                margin: EdgeInsets.only(left: 140),
                child: Text(
                  '처리중',
                  style: TextStyle(color: Colors.orange, fontSize: 17),
                ),
              )
            else
              Container(
                margin: EdgeInsets.only(left: 140),
                child: Text(
                  '미처리',
                  style: TextStyle(color: Colors.red, fontSize: 17),
                ),
              )
          ],
        ),
      ),
    );
  }
}
