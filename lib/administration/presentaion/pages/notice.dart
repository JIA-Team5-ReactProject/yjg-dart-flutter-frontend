import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  int currentPage = 1;
  int? lastPage;
  static final storage = FlutterSecureStorage(); //정원이가 말해준 코드(토큰)

  @override
  void initState() {
    super.initState();
    fetchNotices(currentPage, "admin");
  }

  Future<void> fetchNotices(int page, String tag) async {
    final token = await storage.read(key: 'auth_token'); //정원이가 말해준 코드(토큰 불러오기)
    final response = await http.get(
      Uri.parse('$apiURL/api/notice?page=$page'),
      headers: {
        "Content-Type": "application/json",
        "Authorization"://아래에 토큰을 $token으로 바꿔줘야함
            "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        notices = Future.value(List<dynamic>.from(data['notices']['data']));
        lastPage = data['notices']['last_page'];
      });
    } else {
      print('Failed to load notices. Status Code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: '공지사항'),
      drawer: const BaseDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: notices,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No notices available'));
                } else {
                  return _buildNoticesList(snapshot.data!);
                }
              },
            ),
          ),
          if (lastPage != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(lastPage!, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        currentPage = index + 1;
                        fetchNotices(currentPage, "admin");
                      });
                    },
                    style: TextButton.styleFrom(
                      // 여기서 텍스트 버튼의 배경색, 테두리 등을 설정할 수 있음.
                      backgroundColor: Colors.transparent,
                      // 테두리 제거
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        // 숫자의 색상 설정
                        color: Color.fromARGB(255, 29, 127, 159),
                        // 필요하다면 글꼴 크기, 두께 등을 추가로 설정할 수 있음.
                      ),
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildNoticesList(List<dynamic> notices) {
    // 긴급 공지사항과 일반 공지사항을 분류
    final urgentNotices = notices.where((n) => n['urgent'] == 1).toList();
    final regularNotices = notices.where((n) => n['urgent'] == 0).toList();

    return ListView(
      children: [
        _buildSection('긴급공지', urgentNotices, true),
        _buildSection('공지사항', regularNotices, false),
      ],
    );
  }

  Widget _buildSection(String title, List<dynamic> notices, bool isUrgent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isUrgent ? Colors.red : Colors.black,
            ),
          ),
        ),
        _buildSectionDivider(),
        if (notices.isNotEmpty)
          ...notices
              .map((notice) => _buildNoticeCard(notice, isUrgent))
              .toList(),
      ],
    );
  }

  Widget _buildNoticeCard(dynamic notice, bool isUrgent) {
    final titleStyle = TextStyle(
      color: isUrgent ? Colors.red : Colors.black,
      fontWeight: FontWeight.bold,
    );
    final dateStyle = TextStyle(color: Colors.grey);
    final dateFormat = DateFormat('yyyy-MM-dd');

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
            offset: Offset(0, 2),
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
              SizedBox(height: 5),
              Text(dateFormat.format(DateTime.parse(notice['updated_at'])),
                  style: dateStyle),
            ],
          ),
        ),
        collapsed: Icon(Icons.arrow_drop_down, color: Colors.grey),
        expanded: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Html(data: notice['content']),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 1,
      color: Colors.black,
    );
  }
}
