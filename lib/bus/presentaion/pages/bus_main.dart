import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/bus/presentaion/viewmodels/bus_main_button.dart';
import 'package:yjg/bus/presentaion/viewmodels/notice_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/notice_box.dart';
import 'package:yjg/shared/widgets/white_main_rounded_box.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';

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
      appBar: BaseAppBar(title: 'bus.appbar'.tr()),
      drawer: BaseDrawer(),
      body: SingleChildScrollView(
        // SingleChildScrollView 추가하여 스크롤 가능하도록 수정
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
                        mainText: 'bus.qrRoundedBox.title'.tr(),
                        secondaryText: 'bus.qrRoundedBox.description'.tr(),
                        actionText: 'bus.qrRoundedBox.textButton'.tr(),
                        page: 'bus',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: Text(
                'bus.descriptionText.title1'.tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            BusMainButton(),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: Text(
                'bus.descriptionText.title2'.tr(),
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
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/notice_detail',
                            arguments: notice.id, // 공지사항의 ID를 인자로 전달
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: NoticeBox(
                            title: notice.title ?? '제목 없음',
                            content: notice.content ?? '내용 없음',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(
                  child: CircularProgressIndicator(
                color: Palette.stateColor4,
              )),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ],
        ),
      ),
    );
  }
}
