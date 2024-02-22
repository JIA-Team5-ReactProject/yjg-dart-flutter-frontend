import "package:flutter/material.dart";
import 'package:yjg/shared/widgets/as_comment_box.dart';
import "package:yjg/as(admin)/presentation/widgets/as_floating_button.dart";
import 'package:yjg/shared/widgets/as_image_view.dart';
import "package:yjg/as(admin)/presentation/widgets/as_notice_box.dart";
import "package:yjg/as(admin)/presentation/widgets/service_requester.dart";
import "package:yjg/shared/theme/theme.dart";
import "package:yjg/shared/widgets/base_appbar.dart";
import "package:yjg/shared/widgets/base_drawer.dart";
import "package:yjg/shared/widgets/bottom_navigation_bar.dart";
import "package:yjg/shared/widgets/custom_singlechildscrollview.dart";
import 'package:intl/intl.dart';

class AsDetail extends StatelessWidget {
  final String? asTitle = '거실등 고장났어요 우야죠'; // 임시데이터
  final String? asDate =
      DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()); // 임시데이터
  final String? asContent =
      "안녕하세요? 글로벌생활관 B동 101호인데여 거실등이 고장 났어요 살려주세요 ㅠㅠ 자세한 건 사진참고좀";
  final int? commentCount = 0;
  final int? fileCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: 'AS관리'),
      drawer: const BaseDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      floatingActionButton: AsFloatingButton(),
      body: CustomSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                asTitle!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                asDate!.toString(),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Divider(
                  color: Palette.stateColor4.withOpacity(0.2),
                  thickness: 1.0,
                ),
              ),
              SizedBox(height: 15.0),
              AsNoticeBox(),
              ServiceRequester(),
              // Padding(
              //   padding: const EdgeInsets.only(top: 5.0, bottom: 30.0),
              //   child: Divider(
              //     color: Palette.stateColor4.withOpacity(0.2),
              //     thickness: 1.0,
              //   ),
              // ),
              
              Padding(
                padding: const EdgeInsets.only(bottom: 100.0, top: 50.0),
                child: Text(asContent!),
              ),
          
              Text(
                "첨부파일($fileCount)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20.0,
              ),
              AsImageView(),
              SizedBox(
                height: 50.0,
              ),
              Text(
                "댓글($commentCount)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              AsCommentBox(),
            ],
          ),
        ),
      ),
    );
  }
}
