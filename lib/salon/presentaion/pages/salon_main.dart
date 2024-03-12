import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/presentaion/viewmodels/reservations_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
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

  // 페이지 진입 시에 초기화 작업을 수행
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.refresh(reservationsProvider));
  }

  @override
  Widget build(BuildContext context) {
    final reservationsAsyncValue = ref.watch(reservationsProvider);

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: '미용실'),
      drawer: const BaseDrawer(),
      body: reservationsAsyncValue.when(
        data: (reservations) {
          final bool hasReservations = reservations.isNotEmpty;
          return SingleChildScrollView(
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
                            iconData: Icons.cut,
                            mainText: hasReservations
                                ? '미용실 예약이 있습니다.'
                                : '미용실 예약이 없습니다.',
                            secondaryText: hasReservations
                                ? '예약 시간을 꼭 지켜주세요.'
                                : "미용실을 이용해 보세요!",
                            actionText: '예약 확인하기',
                            page: 'salon',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  alignment: const Alignment(-0.85, 0.2),
                  child: const Text(
                    '미용실 이용하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.all(20),
                  alignment: const Alignment(-0.85, 0.2),
                  child: const Text(
                    '미용실 공지사항',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 140.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: NoticeBox(
                          title: '미용실 휴무 안내',
                          content:
                              '미용실 휴무합니다. 2025년 1월 1일부터 2025년 1월 3일까지 휴무이므로, 이용....',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: NoticeBox(
                          title: '미용실 휴무 안내',
                          content:
                              '미용실 휴무합니다. 2025년 1월 1일부터 2025년 1월 3일까지 휴무이므로, 이용....',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: NoticeBox(
                          title: '미용실 휴무 안내',
                          content:
                              '미용실 휴무합니다. 2025년 1월 1일부터 2025년 1월 3일까지 휴무이므로, 이용....',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
            child: CircularProgressIndicator(color: Palette.stateColor4)),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
