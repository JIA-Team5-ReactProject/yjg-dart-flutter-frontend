import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:yjg/administration/data/data_sources/notice_data_source.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';

class NoticeDetailPage extends StatefulWidget {
  final int noticeId; // 공지사항 ID를 저장하는 필드

  const NoticeDetailPage({Key? key, required this.noticeId}) : super(key: key);

  @override
  State<NoticeDetailPage> createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  late Future<dynamic> noticeDetailFuture;
  final PageController _pageController = PageController();

  final _noticeDataSource = NoticeDataSource();

  @override
  void initState() {
    super.initState();
    noticeDetailFuture = fetchNoticeDetail(widget.noticeId);
  }

  // * 특정 공지사항 불러오는 GET API
  Future<dynamic> fetchNoticeDetail(int noticeId) async {
    try {
      final response = await _noticeDataSource.getNotice(noticeId);
      return response.data['notice'];
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
      body: FutureBuilder<dynamic>(
        future: noticeDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child:
                    Text('notice.error'.tr(args: [snapshot.error.toString()])));
          } else if (!snapshot.hasData) {
            return Center(child: Text('notice.notFound'.tr()));
          } else {
            final notice = snapshot.data;
            List<dynamic> noticeImages = notice['notice_images'];
            final dateFormat = DateFormat('yyyy-MM-dd');
            final formattedDate =
                dateFormat.format(DateTime.parse(notice['updated_at']));

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildTitleAndDateRow(notice['title'], formattedDate),
                  SizedBox(height: 10),
                  _buildCustomRow(Html(data: notice['content'])),
                  SizedBox(height: 20),
                  if (noticeImages.isNotEmpty) _buildImageGallery(noticeImages),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTitleAndDateRow(String title, String date) {
    double screenWidth = MediaQuery.of(context).size.width; // 현재 화면의 너비를 얻습니다.
    return Container(
      width: screenWidth * 0.9, // 컨테이너의 너비를 화면 너비의 90%로 설정합니다.
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 162, 162, 162),
            width: 2, // 여기에서 테두리의 두께를 설정합니다.
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 20, // 글자 크기를 크게 설정
              fontWeight: FontWeight.bold, // 글자를 볼드로 설정
              color: Colors.black, // 글자 색상 설정
            ),
          ),
          SizedBox(height: 8),
          Text(
            date,
            style: TextStyle(
              fontSize: 14, // 날짜 글자 크기 설정
              color: Colors.grey, // 날짜 글자 색상 설정
            ),
          ), // 날짜 출력
        ],
      ),
    );
  }

  Widget _buildCustomRow(Widget content) {
    double screenWidth = MediaQuery.of(context).size.width; // 현재 화면의 너비
    return Container(
      width: screenWidth * 0.9, // 컨테이너의 너비를 화면 너비의 90%
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 162, 162, 162),
            width: 2, // 여기에서 테두리의 두께를 설정합니다.
          ),
        ),
      ),
      constraints: BoxConstraints(minHeight: 200), // 컨테이너의 최소 높이를 설정
      child: content,
    );
  }

  Widget _buildImageGallery(List<dynamic> noticeImages) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color.fromARGB(255, 162, 162, 162), width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: noticeImages.length,
            itemBuilder: (context, index) {
              // 이미지를 GestureDetector로 감싸서 탭 이벤트를 처리합니다.
              return GestureDetector(
                onTap: () =>
                    _showFullScreenImage(context, noticeImages[index]['image']),
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // 사진과 테두리 사이의 여백을 설정합니다.
                  child: Image.network(
                    noticeImages[index]['image'],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          Positioned(
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: Color.fromARGB(255, 162, 162, 162), size: 20),
              onPressed: () {
                _pageController.previousPage(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
          Positioned(
            right: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios,
                  color: Color.fromARGB(255, 162, 162, 162), size: 20),
              onPressed: () {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // 이미지 전체 화면을 표시하는 다이얼로그입니다.
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.black,
            child: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _navigationArrow(IconData icon, Function onTap, Alignment alignment) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: alignment == Alignment.centerLeft ? 10 : null,
      right: alignment == Alignment.centerRight ? 10 : null,
      child: IconButton(
        icon: Icon(icon,
            color: Color.fromARGB(255, 162, 162, 162), size: 20), // 아이콘 크기 조절
        onPressed: onTap as void Function()?,
        splashColor: Colors.transparent, // 스플래시 색상 제거
        highlightColor: Colors.transparent, // 하이라이트 색상 제거
      ),
    );
  }
}
