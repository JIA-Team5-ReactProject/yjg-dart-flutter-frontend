import 'package:flutter/material.dart';
import 'package:yjg/administration/data/data_sources/notice_data_source.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

class Notice extends StatefulWidget {
  const Notice({Key? key}) : super(key: key);

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  Future<List<dynamic>>? notices;
  int currentPage = 1;
  int? lastPage;
  final _noticeDatasource = NoticeDataSource();
  @override
  void initState() {
    super.initState();
    fetchNotices(currentPage, "admin");
  }

  // * 공지사항 불러오는 GET API
  Future<void> fetchNotices(int page, String tag) async {
    try {
      final response = await _noticeDatasource.fetchNotices(page, tag);
      final data = response.data;
      setState(() {
        notices = Future.value(List<dynamic>.from(data['notices']['data']));
        lastPage = data['notices']['last_page'];
      });
    } catch (e) {
      throw Exception('notice.loadFailed'.tr(args: [e.toString()]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: 'notice.title'.tr()),
      drawer: BaseDrawer(),
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
                  return Center(
                      child: Text('notice.error'
                          .tr(args: [snapshot.error.toString()])));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('notice.noNotices'.tr()));
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
        _buildSection('notice.urgent'.tr(), urgentNotices, true),
        _buildSection('notice.regular'.tr(), regularNotices, false),
      ],
    );
  }

  Widget _buildSection(String title, List<dynamic> notices, bool isUrgent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30, top: 20),
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

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/notice_detail', arguments: notice['id']);
      },
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85, // 카드의 가로 크기 설정
          margin: const EdgeInsets.symmetric(vertical: 8), // 상하 여백 설정
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
          child: Padding(
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
        ),
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      height: 2,
      color: const Color.fromARGB(255, 126, 126, 126),
    );
  }
}
