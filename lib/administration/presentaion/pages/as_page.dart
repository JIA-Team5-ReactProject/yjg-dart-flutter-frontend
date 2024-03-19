import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/widgets/as_card.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AsPage extends StatefulWidget {
  const AsPage({super.key});

  @override
  State<AsPage> createState() => _AsPageState();
}

class _AsPageState extends State<AsPage> {
  static final storage = FlutterSecureStorage(); //정원이가 말해준 코드(토큰)

  // API 통신 함수 (AS카드에 쓸 데이터 불러오기)
  Future<List<dynamic>> fetchASRequests() async {
    try {
      final token = await storage.read(key: 'auth_token'); //정원이가 말해준 코드(토큰 불러오기)
      final response = await http.get(
        Uri.parse('$apiURL/api/after-service/user'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return data['after_services'];
      } else {
        print('Server returned ${response.statusCode}');
        throw Exception('Failed to load AS requests');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to fetch AS requests');
    }
  }

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
              future: fetchASRequests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("에러(as_page.dart)"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('현재 요청된 AS가 없습니다.',style: TextStyle(color: Colors.grey),));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var asRequest = snapshot.data![index];
                      return AsCard(
                        id: asRequest['id'], // 각 AS 요청의 고유 ID를 AsCard에 전달
                        state: asRequest['status'], // status를 state에 연결
                        title: asRequest['title'], // title을 title에 연결
                        day: asRequest['visit_date'], // visit_date를 day에 연결
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
