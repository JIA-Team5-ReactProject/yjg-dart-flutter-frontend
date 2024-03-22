import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/administration/presentaion/widgets/sleepover_widget.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Sleepover extends StatefulWidget {
  const Sleepover({Key? key}) : super(key: key);

  @override
  State<Sleepover> createState() => _SleepoverState();
}

class _SleepoverState extends State<Sleepover> {
  
  static final storage = FlutterSecureStorage(); //정원이가 말해준 코드(토큰)
  Future<List<dynamic>>? _sleepoverApplications;

  @override
  void initState() {
    super.initState();
    _loadSleepoverApplications();
  }

  void _loadSleepoverApplications() {
    setState(() {
      _sleepoverApplications = fetchSleepoverApplications();
    });
  }


  Future<List<dynamic>> fetchSleepoverApplications() async {

    final token = await storage.read(key: 'auth_token'); //정원이가 말해준 코드(토큰 불러오기)

    final response = await http.get(
      Uri.parse('$apiURL/api/absence/user'),
      headers: {
        "Content-Type": "application/json",//아래 토큰 $token으로 바꿔줘야함(로그인 연동)
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result is Map &&
          result.containsKey('absence_lists') &&
          result['absence_lists']['data'] is List) {
        return result['absence_lists']['data'];
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load sleepover applications');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: '외박/외출'),
      drawer: BaseDrawer(),
      body: Column(
        children: [
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
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 244, 244, 244)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/sleepover_application');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.note_add_outlined, size: 30),
                        SizedBox(width: 10),
                        Text('외박/외출 신청하기'),
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
            margin: EdgeInsets.only(left: 20, top: 20, bottom: 10),
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
          
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _sleepoverApplications,
              builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('현재 신청된 외박/외출이 없습니다.',style: TextStyle(color: Colors.grey),));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final application = snapshot.data![index];
                      return InkWell(
                        onTap: () async {
                          final result = await showDialog<bool>(
                            context: context,
                            builder: (context) => SleepoverWidget(
                              id: application['id'],
                              apply: application['status'],
                              startDate: application['start_date'],
                              lastDate: application['end_date'],
                              content: application['content'],
                            ),
                          );

                          if (result == true) {
                            _loadSleepoverApplications();
                          }
                        },
                        child: SleepoverWidget(
                          id: application['id'],
                          apply: application['status'],
                          startDate: application['start_date'],
                          lastDate: application['end_date'],
                          content: application['content'],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}