import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:yjg/salon/presentaion/viewmodels/admin_reservation_viewmodel.dart";
import "package:yjg/salon/presentaion/viewmodels/notice_viewmodel.dart";
import "package:yjg/salon/presentaion/widgets/admin/main_rounded_box.dart";
import "package:yjg/shared/theme/palette.dart";
import "package:yjg/shared/widgets/base_appbar.dart";
import "package:yjg/shared/widgets/blue_main_rounded_box.dart";
import "package:yjg/shared/widgets/bottom_navigation_bar.dart";
import "package:yjg/shared/widgets/move_button.dart";
import "package:yjg/shared/widgets/notice_box.dart";

class AdminSalonMain extends ConsumerStatefulWidget {
  const AdminSalonMain({Key? key}) : super(key: key);

  @override
  _AdminSalonMainState createState() => _AdminSalonMainState();
}

class _AdminSalonMainState extends ConsumerState<AdminSalonMain> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.refresh(noticeProvider);

      // 현재 날짜로 초기 데이터 로딩
      final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      ref
          .read(reservationViewModelProvider.notifier)
          .fetchReservations(reservationDate: currentDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final noticesAsyncValue = ref.watch(noticeProvider);
    final reservationsAsyncValue = ref.watch(reservationViewModelProvider);

    // 모든 작업이 완료되었는지 확인
    final allLoaded = reservationsAsyncValue.maybeWhen(
            data: (_) => true, orElse: () => false) &&
        noticesAsyncValue.maybeWhen(data: (_) => true, orElse: () => false);

    // 하나라도 로딩 중인지 확인
    final isLoading = reservationsAsyncValue is AsyncLoading ||
        noticesAsyncValue is AsyncLoading;

    return Scaffold(
      appBar: const BaseAppBar(title: "미용실"),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Palette.stateColor4))
          : SingleChildScrollView(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: MainRoundedBox(
                              iconData: Icons.cut,
                              mainText: '금일 확정 예약',
                              actionText: '자세히 보기',
                              // 예약 개수를 동적으로 업데이트
                              bookText: reservationsAsyncValue.when(
                                data: (reservations) =>
                                    '${reservations.where((reservation) => reservation.status == 'confirm').length}건',
                                loading: () => '로딩 중...',
                                error: (_, __) => '오류 발생',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 나머지 UI 구성 부분
                  Container(
                    margin: const EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      '미용실 관리',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                          route: '/admin_salon_booking'),
                      MoveButton(
                          icon: Icons.content_paste_search,
                          text1: '가격표',
                          text2: '미용실 이용 가격 안내',
                          route: '/admin_salon_price_list'),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  // 공지사항 섹션
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      '미용실 공지사항',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  noticesAsyncValue.when(
                    data: (notices) => SizedBox(
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
                    ),
                    loading: () => const Center(
                        child: CircularProgressIndicator(
                            color: Palette.stateColor4)),
                    error: (error, _) => Center(child: Text('Error: $error')),
                  ),
                ],
              ),
            ),
    );
  }
}
