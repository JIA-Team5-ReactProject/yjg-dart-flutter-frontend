import 'package:flutter/material.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:timer_count_down/timer_count_down.dart';

class BusQr extends StatefulWidget {
  const BusQr({super.key});

  @override
  State<BusQr> createState() => _BusQrState();
}

class _BusQrState extends State<BusQr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 127, 159),
      appBar: BaseAppBar(title: '버스QR'),
      drawer: const BaseDrawer(),
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 50, right: 50),
            width: 500,
            height: 550,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [

                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 15,left: 10),
                  child: Row(
                    children: [
                      //뒤로가기 버튼
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.keyboard_return),
                        color: const Color.fromARGB(255, 29, 127, 159),
                      ),
                      SizedBox(
                        width: 40,
                      ),

                      //식당 QR코드 글자
                      Text(
                        '버스 QR 코드',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 29, 127, 159),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                //~~~글자
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text(
                    '버스 탑승 시 단말기에 QR 코드를 찍어주세요.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),

                //카운트 다운
                Countdown(
                  seconds: 15,
                  build: (_, double time) => Text(
                    time.toInt().toString(),
                    style: TextStyle(
                      fontSize: 35,
                    ),
                  ),
                  onFinished: () {
                    Navigator.pop(context);
                  },
                ),

                //QR여기에 넣기
                Container(
                  width: 220,
                  height: 220,
                  color: Colors.black,
                ),


                //구분 점선
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: const Text(
                      '............................................................',
                      style:
                          TextStyle(color: Color.fromARGB(255, 173, 173, 173))),
                ),

                //학번 글자
                Text('1901201',style: TextStyle(
                  color: Color.fromARGB(255, 148, 148, 148),
                  fontSize: 15
                ),),

                //이름 글자
                Text('이민혁',style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 23,
                  fontWeight: FontWeight.bold
                ),),

                //학과 글자
                Text('컴퓨터정보계열',style: TextStyle(
                  color: Color.fromARGB(255, 29, 127, 159),
                  fontSize: 15
                ),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
