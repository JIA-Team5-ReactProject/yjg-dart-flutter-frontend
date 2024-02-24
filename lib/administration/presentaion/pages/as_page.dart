import 'package:flutter/material.dart';
import 'package:yjg/shared/widgets/as_card.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';

class AsPage extends StatefulWidget {
  const AsPage({super.key});

  @override
  State<AsPage> createState() => _AsPageState();
}

class _AsPageState extends State<AsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: 'AS요청'),
      drawer: const BaseDrawer(),
      body: Column(
        children: [
          //AS 신청하기 버튼
          SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: [
                BlueMainRoundedBox(),
                //신청하기 버튼
                Container(
                  width: 260,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 244, 244, 244)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          // 버튼 모서리를 둥글게 설정
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                    ),
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/as_application');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_add_outlined,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('AS 신청하기')
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          //신청 내역 글자
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 20, top: 20,bottom: 10),
            child: Text('신청 내역'),
          ),

          //선
          Container(
            width: 380,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Color.fromARGB(255, 0, 0, 0))),
            ),
          ),

          AsCard(state: 1, title: '거실등 수리', day: '2024-02-15'),
          AsCard(state: 2, title: '커튼 고장', day: '2024-02-14'),
          AsCard(state: 3, title: '변기 막힘', day: '2024-02-13'),
        ],
      ),
    );
  }
}
