import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:expandable/expandable.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

class Notice extends StatefulWidget {
  const Notice({Key? key}) : super(key: key);

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  Future<List<dynamic>>? notices;

  @override
  void initState() {
    super.initState();
    // API 호출로 공지사항 데이터를 불러옴.
    notices = fetchNotices(1, "admin");
  }

  // API에서 공지사항 데이터를 불러오는 함수
  Future<List<dynamic>> fetchNotices(int page, String tag) async {
    final response = await http.get(
      Uri.parse('$apiURL/api/notice?page=$page&tag=$tag'),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer 13|y5vvDb8bDwmlaatERjwsz1kprQxT8QcqEuXuwBnz90506e72" //쓸때마다 변경
      },
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // API 응답에서 'data' 키 안의 'notices' 배열에 접근하여 리스트 반환
      return List<dynamic>.from(data['notices']['data']);
    } else {
      print(
          'Failed to load notices. Status Code: ${response.statusCode}. Response Body: ${response.body}');
      throw Exception('Failed to load notices');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: '공지사항'),
      drawer: const BaseDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: FutureBuilder<List<dynamic>>(
        future: notices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // 공지사항 데이터를 화면에 표시합니다.
            return _buildNoticesList(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildNoticesList(List<dynamic> notices) {
    final urgentNotices = notices.where((n) => n['urgent'] == 1).toList();
    final regularNotices = notices.where((n) => n['urgent'] == 0).toList();

    return ListView(
      children: [
        //긴급 공지사항 칸 나눔 컨테이너
        Container(
          margin: EdgeInsets.only(left: 20, top: 20),
          child: Column(
            children: [
              //긴급 공지사항 글자
              Row(
                children: [
                  Text(
                    '긴급공지',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '!',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              //선
              _buildSectionDivider()
            ],
          ),
        ),

        //긴급 공지사항 목록
        ...urgentNotices
            .map((notice) => _buildNoticeCard(notice, true))
            .toList(),

        //일반 공지사항 칸 나눔 컨테이너
        Container(
          margin: EdgeInsets.only(left: 20, top: 20),
          child: Column(
            children: [
              //일반 공지사항 글자
              Row(
                children: [
                  Text(
                    '공지사항',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              //선
              _buildSectionDivider()
            ],
          ),
        ),

        //일반 공지사항 목록
        ...regularNotices
            .map((notice) => _buildNoticeCard(notice, false))
            .toList(),
      ],
    );
  }

  Widget _buildNoticeCard(dynamic notice, bool isUrgent) {
    final titleStyle = TextStyle(
      color: isUrgent ? Colors.red : Colors.black,
      fontWeight: FontWeight.bold,
    );
    final dateStyle = TextStyle(
      color: Colors.grey,
    );
    final dateFormat = DateFormat('yyyy-MM-dd'); // 날짜 포맷 설정

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: ExpandablePanel(
        theme: ExpandableThemeData(
          hasIcon: false,
          tapBodyToExpand: true,
          tapBodyToCollapse: true,
          tapHeaderToExpand: true,
        ),
        header: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notice['title'], style: titleStyle),
              SizedBox(height: 5), // 타이틀과 날짜 사이 간격 추가
              Text(
                dateFormat.format(DateTime.parse(notice['updated_at'])),
                style: dateStyle,
              ),
            ],
          ),
        ),
        collapsed:
            Icon(Icons.arrow_drop_down, color: Colors.grey), // 화살표 아이콘 추가

        expanded: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Html(data: notice['content']),
            if (notice['notice_images'] != null &&
                notice['notice_images'].isNotEmpty)
              Container(
                height: 200, // 이미지 높이 설정
                margin: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: notice['notice_images'].length,
                  itemBuilder: (context, index) {
                    // 이 부분에 GestureDetector를 적용합니다.
                    return GestureDetector(
                      onTap: () => showImageDialog(
                          context, notice['notice_images'][index]['image']),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            notice['notice_images'][index]['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // 중앙 정렬로 변경
      children: [
        Container(
          width: 380, // 너비는 조정해야 할 수 있음
          height: 1,
          color: Colors.black,
        ),
      ],
    );
  }

  void showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.pop(context), // 다이얼로그 닫기
            child: Center(
              child: Image.network(imageUrl),
            ),
          ),
        );
      },
    );
  }
}
