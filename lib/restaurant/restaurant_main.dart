import 'package:flutter/material.dart';

class RestaurantMain extends StatefulWidget {
  const RestaurantMain({super.key});

  @override
  State<RestaurantMain> createState() => _RestaurantMainState();
}

class _RestaurantMainState extends State<RestaurantMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const Icon(
          Icons.menu,
          color: Colors.white,
          size: 40,
        ),
        backgroundColor: Color.fromARGB(255, 29, 127, 159),
        title: const Center(
          child: Text(
            '식수',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //조,중,석식 메뉴 표시 DB연동 필요
            Container(
              height: 200.0,
              color: Color.fromARGB(255, 29, 127, 159),
              child: ListView(
                scrollDirection: Axis.horizontal, // 가로로 스크롤
                children: <Widget>[
                  mealCard('오늘 조식', ['신라면', '김치']),
                  mealCard('오늘 중식', ['안성탕면', '김치']),
                  mealCard('오늘 석식', ['진라면(매)', '김치']),
                ],
              ),
            ),

            //식수 이용하기 글자
            Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment(-0.85, 0.2),
              child: Text(
                '식수 이용하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            //이동 버튼 배치
            Wrap(
              spacing: 30, // 아이템들 사이의 가로 간격
              runSpacing: 30, // 아이템들 사이의 세로 간격
              children: <Widget>[
                buildButton(context, Icons.backup_table, '식단표', '이번 일주일 식단표',
                    '/menu_list'),
                buildButton(
                    context, Icons.qr_code, '식수 QR', '식사 시 QR 찍기', ''),
                buildButton(
                    context, Icons.calendar_month, '주말 식수', '주말 식수 신청', ''),
                buildButton(context,Icons.assignment_turned_in, '식수 신청', '식사 신청', ''),
              ],
            ),

            //현재 주말 식수 신청 인원 현황 수
            Container(
              height: 60,
              width: 330,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color.fromARGB(255, 139, 139, 139),
                  width: 0.5,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.group,size: 40,color: Color.fromARGB(255, 29, 127, 159),),
                  ), // 왼쪽 아이콘
                  SizedBox(width: 10), // 아이콘과 텍스트 사이의 간격
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('현재 주말식수 신청 인원'), // 중간 텍스트
                      Text(
                        '토요일: n명 | 일요일 n명', // 아래 텍스트
                        style: TextStyle(color: Color.fromARGB(255, 29, 127, 159),),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

//조식, 중식, 석식 메뉴 위젯
Widget mealCard(String meal, List<String> menu) {
  return Container(
    width: 150.0,
    margin: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Text(meal,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 29, 127, 159),
              )),
          const SizedBox(height: 5),
          Column(children: menu.map((item) => Text(item)).toList()),
        ],
      ),
    ),
  );
}

//이동 버튼 위젯 디자인
var BoxStyle = BoxDecoration(
  boxShadow: const [
    // 그림자
    BoxShadow(
      color: Color.fromARGB(255, 185, 183, 183), //그림자 색상
      spreadRadius: 2, // 그림자 넓이
      blurRadius: 5, // 그림자 흐림도
      offset: Offset(3, 3), // 그림자가 박스랑 얼마나 떨어져서 나타날지
    ),
  ],
  border: Border.all(color: Color.fromARGB(255, 139, 139, 139), width: 0.5),
  color: Colors.white,
  borderRadius: BorderRadius.circular(15.0),
);

//이동 버튼 위젯
Widget buildButton(BuildContext context, IconData icon, String text1,
    String text2, String route) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, route); // 각 버튼에 맞는 페이지로 이동
    },
    child: Container(
      width: 150,
      height: 170,
      decoration: BoxStyle,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: Color.fromARGB(255, 29, 127, 159), size: 50.0), // 아이콘
          SizedBox(height: 10.0), // 아이콘과 글자 사이의 간격
          Text(
            text1,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ), // 첫 번째 글자
          Text(
            text2,
            style: TextStyle(color: Colors.black, fontSize: 10),
          ), // 두 번째 글자
        ],
      ),
    ),
  );
}
