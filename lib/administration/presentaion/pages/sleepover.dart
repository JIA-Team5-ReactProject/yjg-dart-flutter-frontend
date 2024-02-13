import 'package:flutter/material.dart';
import 'package:yjg/administration/presentaion/widget/sleepover_widget.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';

class Sleepover extends StatefulWidget {
  const Sleepover({super.key});

  @override
  State<Sleepover> createState() => _SleepoverState();
}

class _SleepoverState extends State<Sleepover> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: '외박/외출'),
      drawer: const BaseDrawer(),
      body: Column(
        children: [
          
          //외박/외출 신청 버튼
          SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: [
                BlueMainRoundedBox(),
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
                        Navigator.pushNamed(context, '/sleepover_application');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.note_add_outlined,size: 30,),
                          SizedBox(
                            width: 10,
                          ),
                          Text('외박/외출 신청하기')
                        ],
                      ),
                    ),
                  ),
              ],
              
            ),
          ),
         
         SleepoverWidget(apply: true,StartDate: '2024/02/12',LastDate: '2024/02/15'),
         SleepoverWidget(apply: false,StartDate: '2024/03/22',LastDate: '2024/03/23'),
         SleepoverWidget(apply: true,StartDate: '2024/04/12',LastDate: '2024/04/15'),
         SleepoverWidget(apply: true,StartDate: '2024/05/03',LastDate: '2024/05/05'),

      ],
      ),
    );
  }
}