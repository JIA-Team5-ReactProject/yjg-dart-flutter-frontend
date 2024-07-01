import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/presentaion/viewmodels/notice_viewmodel.dart';
import 'package:yjg/salon/presentaion/viewmodels/reservations_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/notice_box.dart';
import 'package:yjg/shared/widgets/white_main_rounded_box.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/move_button.dart';

import '../../../shared/widgets/base_drawer.dart';

class SalonMain extends ConsumerStatefulWidget {
  const SalonMain({Key? key}) : super(key: key);

  @override
  _SalonMainState createState() => _SalonMainState();
}

class _SalonMainState extends ConsumerState<SalonMain> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.refresh(reservationsProvider);
      ref.refresh(noticeProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reservationsAsyncValue = ref.watch(reservationsProvider);
    final noticesAsyncValue = ref.watch(noticeProvider);

    // 화면의 가로 길이
    final screenWidth = MediaQuery.of(context).size.width;
    // 버튼의 가로 길이
    final buttonWidth = (screenWidth - 90) / 2;
    // 세로 길이 설정
    final buttonHeight = buttonWidth * 1.05;

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: BaseAppBar(title: 'salon.appbar'.tr()),
      drawer: BaseDrawer(),
      body: Stack(
        children: [
          AnimatedSwitcher(
            // 두 개의 비동기 상태를 모두 로딩이 완료되면 페이지 내용을 표시
            duration: const Duration(milliseconds: 300),
            child: (reservationsAsyncValue.when(
                      data: (_) => true,
                      loading: () => false,
                      error: (_, __) => true,
                    ) &&
                    noticesAsyncValue.when(
                      data: (_) => true,
                      loading: () => false,
                      error: (_, __) => true,
                    ))
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 예약 정보
                        reservationsAsyncValue.when(
                          data: (reservations) {
                            final bool hasReservations =
                                reservations.isNotEmpty;
                            return SizedBox(
                              height: 150.0,
                              child: Stack(
                                children: [
                                  const BlueMainRoundedBox(),
                                  Positioned(
                                    top: 15,
                                    left: 0,
                                    right: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: WhiteMainRoundedBox(
                                        iconData: Icons.cut,
                                        mainText: hasReservations
                                            ? 'salon.bookingRoundedBox.title1'.tr()
                                            : 'salon.bookingRoundedBox.title2'.tr(),
                                        secondaryText: hasReservations
                                            ? 'salon.bookingRoundedBox.description1'
                                                .tr()
                                            : 'salon.bookingRoundedBox.description2'
                                                .tr(),
                                        actionText: 'salon.bookingRoundedBox.textButton'
                                            .tr(),
                                        page: 'salon',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          loading: () => Container(), // 로딩 중에는 이미 인디케이터를 표시함
                          error: (error, _) =>
                              Center(child: Text('Error: $error')),
                        ),
                        // 이용 안내
                        Container(
                          margin: const EdgeInsets.all(20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'salon.descriptionText.title1'.tr(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.0),
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2, // 한 줄에 2개씩 배치
                            mainAxisSpacing: 20.0,
                            crossAxisSpacing: 15.0,
                            childAspectRatio:
                                buttonWidth / buttonHeight, // 아이템들 사이의 세로 간격
                            children: <Widget>[
                              MoveButton(
                                  icon: Icons.add_task,
                                  text1: 'salon.salonBooking.title'.tr(),
                                  text2: 'salon.salonBooking.description'.tr(),
                                  route: '/salon_booking_step_one'),
                              MoveButton(
                                  icon: Icons.content_paste_search,
                                  text1: 'salon.salonPriceList.title'.tr(),
                                  text2: 'salon.salonPriceList.description'.tr(),
                                  route: '/salon_price_list'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        // 공지사항
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'salon.descriptionText.title2'.tr(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
                                        arguments:
                                            notice.id, // 공지사항의 ID를 인자로 전달
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
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
                          loading: () => Container(), // 로딩 중에는 이미 인디케이터를 표시함
                          error: (error, _) =>
                              Center(child: Text('Error: $error')),
                        ),
                      ],
                    ),
                  )
                : Container(), // 로딩 중에는 페이지 내용을 숨김
          ),
          // 로딩 인디케이터
          if (reservationsAsyncValue.when(
                data: (_) => false,
                loading: () => true,
                error: (_, __) => false,
              ) ||
              noticesAsyncValue.when(
                data: (_) => false,
                loading: () => true,
                error: (_, __) => false,
              ))
            const Center(
              child: CircularProgressIndicator(color: Palette.stateColor4),
            ),
        ],
      ),
    );
  }
}
