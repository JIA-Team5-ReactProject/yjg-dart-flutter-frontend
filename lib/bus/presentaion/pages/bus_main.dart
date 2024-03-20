import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/bus/presentaion/viewmodels/notice_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/notice_box.dart';
import 'package:yjg/shared/widgets/white_main_rounded_box.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/move_button.dart';

class BusMain extends ConsumerStatefulWidget {
  const BusMain({Key? key}) : super(key: key);

  @override
  _BusMainState createState() => _BusMainState();
}

class _BusMainState extends ConsumerState<BusMain> {
  @override
  Widget build(BuildContext context) {
    final noticesAsyncValue = ref.watch(noticeProvider);

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: '버스'),
      drawer: const BaseDrawer(),
      body: SingleChildScrollView( // SingleChildScrollView 추가하여 스크롤 가능하도록 수정
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 150.0,
              child: Stack(
                children: [
                  const BlueMainRoundedBox(),
                  Positioned(
                    top: 15,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: WhiteMainRoundedBox(
                        iconData: Icons.directions_bus,
                        mainText: '글로벌캠퍼스',
                        secondaryText: '탑승인원: 12명(45인승)',
                        actionText: '위치 변경',
                        timeText: '14:00',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: const Text(
                '버스 이용하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Wrap(
              spacing: 30,
              runSpacing: 30,
              children: <Widget>[
                MoveButton(
                    icon: Icons.schedule,
                    text1: '시간표',
                    text2: '버스 시간표 확인',
                    route: '/bus_schedule'),
                MoveButton(
                    icon: Icons.qr_code,
                    text1: '버스QR',
                    text2: '버스 탑승 시 QR 찍기',
                    route: '/bus_qr'),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: const Text(
                '버스 공지사항',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            noticesAsyncValue.when(
              data: (notices) {
                return SizedBox(
                  height: 140.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: notices.length,
                    itemBuilder: (context, index) {
                      final notice = notices[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: NoticeBox(
                          title: notice.title ?? '제목 없음',
                          content: notice.content ?? '내용 없음',
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: Palette.stateColor4,)),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ],
        ),
      ),
    );
  }
}
