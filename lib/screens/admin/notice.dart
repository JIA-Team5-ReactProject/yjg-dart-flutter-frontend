import 'package:flutter/material.dart';
import 'package:yjg/widgets/base_appbar.dart';
import 'package:yjg/widgets/base_drawer.dart';
import 'package:yjg/widgets/bottom_navigation_bar.dart';
import 'package:expandable/expandable.dart';

List<List<String>> emergencyList = [
  ['겨울 한파로 인한 주의 사항','2024-02-08'],
];
List<List<String>> noticeList = [
  ['기숙사비 납부','2024-02-08', '돈 내시오'],
  ['탁구장 공지사항','2024-02-08', '쓰지마시오'],
  ['기숙사 이용 규칙','2024-02-10', '이용하지마시오']
];

class Notice extends StatefulWidget {
  const Notice({super.key});

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: '공지사항'),
      drawer: const BaseDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //긴급공지 글자
            Container(
              margin: EdgeInsets.only(left: 20, top: 20),
              child: Row(
                children: [
                  Text(
                    '!',
                    style: TextStyle(color: Colors.red, fontSize: 23),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '긴급공지',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '!',
                    style: TextStyle(color: Colors.red, fontSize: 23),
                  ),
                ],
              ),
            ),

            //선
            Container(
              width: 380,
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Color.fromARGB(255, 0, 0, 0))),
              ),
            ),

            //긴급공지 사항
            Container(
              width: 360,
              child: Column(
                children: emergencyList.map((item) {
                  return ExpandablePanel(
                    header: Text(item[0]),
                    collapsed: Text(item[1],style: TextStyle(color: const Color.fromARGB(255, 202, 202, 202)),),
                    expanded: Image.asset('assets/img/yju_tiger_logo.png'),
                  );
                }).toList(),
              ),
            ),

            //공지사항 글자
            Container(
              margin: EdgeInsets.only(left: 20, top: 20),
              alignment: Alignment.topLeft,
              child: Text(
                '공지 사항',
                style: TextStyle(fontSize: 18),
              ),
            ),

            //선
            Container(
              width: 380,
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Color.fromARGB(255, 0, 0, 0))),
              ),
            ),

            // 공지사항 리스트
            Container(
              width: 360,
              child: Column(
                children: noticeList.map((item) {
                  return Container(
                    margin: EdgeInsets.only(top: 5,bottom: 10),
                    child: ExpandablePanel(
                      header: Text(item[0]),
                      collapsed: Text(item[1],style: TextStyle(color: const Color.fromARGB(255, 202, 202, 202)),),
                      expanded: Text(item[2]),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
