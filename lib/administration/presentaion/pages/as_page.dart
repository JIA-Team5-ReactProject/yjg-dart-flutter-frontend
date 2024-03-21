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
  List<dynamic> asRequests = [];
  String selectedFilter = '모두보기';
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchASRequests();
  }

  // API 통신 함수 (AS카드에 쓸 데이터 불러오기)
  Future<void> fetchASRequests() async {
    setState(() {
      isLoading = true; // API 호출 시작 시 로딩 상태로 설정
      errorMessage = ''; // 이전 에러 메시지 초기화
    });

    try {
      final token = await storage.read(key: 'auth_token');
      final response = await http.get(
        Uri.parse('$apiURL/api/after-service/user'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          asRequests = data['after_services'];
          isLoading = false; // 로딩 상태 해제
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load AS requests';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  //필터링 해서 API 함수 부르는 함수
  List<dynamic> getFilteredRequests() {
    if (selectedFilter == '처리전') {
      return asRequests.where((req) => req['status'] == 0).toList();
    } else if (selectedFilter == '처리완료') {
      return asRequests.where((req) => req['status'] == 1).toList();
    }
    return asRequests;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredRequests = getFilteredRequests();

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('신청 내역', style: TextStyle(fontSize: 13)),
                DropdownButton<String>(
                  value: selectedFilter,
                  items: [
                    DropdownMenuItem(
                      value: '모두보기',
                      child:
                          Text('모두 보기', style: TextStyle(color: Colors.black,fontSize: 11)),
                    ),
                    DropdownMenuItem(
                      value: '처리전',
                      child: Text('처리 전', style: TextStyle(color: Colors.black,fontSize: 11)),
                    ),
                    DropdownMenuItem(
                      value: '처리완료',
                      child:
                          Text('처리 완료', style: TextStyle(color: Colors.black,fontSize: 11)),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value!;
                    });
                  },
                ),
              ],
            ),
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
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Center(child: Text("에러: $errorMessage"))
                    : filteredRequests.isEmpty
                        ? Center(
                            child: Text(
                              '현재 요청된 AS가 없습니다.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredRequests.length,
                            itemBuilder: (context, index) {
                              var req = filteredRequests[index];
                              return AsCard(
                                id: int.parse(
                                    req['id'].toString()), // 문자열을 정수형으로 변환
                                state: int.parse(
                                    req['status'].toString()), // 문자열을 정수형으로 변환
                                title: req['title'],
                                day: req['visit_date'],
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
