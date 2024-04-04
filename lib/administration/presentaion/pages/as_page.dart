import 'package:flutter/material.dart';
import 'package:yjg/administration/data/data_sources/std_as_data_source.dart';
import 'package:yjg/shared/theme/palette.dart';
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
  List<dynamic> asRequests = [];
  String selectedFilter = '모두보기';
  bool isLoading = true;
  String errorMessage = '';
  final _stdAsDataSource = StdAsDataSource();

  @override
  void initState() {
    super.initState();
    fetchASRequests();
  }

  // * AS 카드 데이터를 불러오는 함수
  Future<void> fetchASRequests() async {
    setState(() {
      isLoading = true; // API 호출 시작 시 로딩 상태로 설정
      errorMessage = ''; // 이전 에러 메시지 초기화
    });

    try {
      final response = await _stdAsDataSource.fetchASRequests();
      final data = response.data as Map<String, dynamic>;
      setState(() {
        asRequests = data['after_services'];
        isLoading = false; // 로딩 상태 해제
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  // 필터링 해서 API 함수 부르는 함수
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
      drawer: BaseDrawer(),
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
          SizedBox(height: 10),

          //신청 내역 글자
          Container(
            margin: EdgeInsets.only(left: 250),
            child: Theme(
              data: Theme.of(context).copyWith(
                popupMenuTheme: PopupMenuThemeData(
                  color: Palette.mainColor,
                ),
              ),
              child: PopupMenuButton<String>(
                onSelected: (String value) {
                  setState(() {
                    selectedFilter = value;
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: '모두보기',
                    child: Text('모두 보기', style: TextStyle(color: Colors.white)),
                  ),
                  const PopupMenuItem<String>(
                    value: '처리 전 ',
                    child: Text('처리 전 ', style: TextStyle(color: Colors.white)),
                  ),
                  const PopupMenuItem<String>(
                    value: '처리완료',
                    child: Text('처리 완료', style: TextStyle(color: Colors.white)),
                  ),
                ],
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  decoration: BoxDecoration(
                    color: Palette.mainColor, // 여기에서 선택 내역 컨테이너의 배경색을 설정합니다.
                    borderRadius: BorderRadius.circular(4), // 모서리를 둥글게 설정합니다.
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        selectedFilter,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 10),

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
