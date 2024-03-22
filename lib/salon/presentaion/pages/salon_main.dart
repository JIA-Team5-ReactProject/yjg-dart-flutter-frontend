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

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: '미용실'),
      body: Stack(
        children: [
          AnimatedSwitcher( // 두 개의 비동기 상태를 모두 로딩이 완료되면 페이지 내용을 표시
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
                                            ? '미용실 예약이 있습니다.'
                                            : '미용실 예약이 없습니다.',
                                        secondaryText: hasReservations
                                            ? '예약 시간을 꼭 지켜주세요.'
                                            : '미용실을 이용해 보세요!',
                                        actionText: '예약 확인하기',
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
                          child: const Text(
                            '미용실 이용하기',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Wrap(
                          spacing: 30,
                          runSpacing: 30,
                          children: <Widget>[
                            MoveButton(
                                icon: Icons.add_task,
                                text1: '예약',
                                text2: '미용실 예약',
                                route: '/salon_booking_step_one'),
                            MoveButton(
                                icon: Icons.content_paste_search,
                                text1: '가격표',
                                text2: '미용실 이용 가격 안내',
                                route: '/salon_price_list'),
                          ],
                        ),
                        // 공지사항
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            '미용실 공지사항',
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
