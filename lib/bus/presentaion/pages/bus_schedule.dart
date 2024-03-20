import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/bus/presentaion/viewmodels/bus_viewmodel.dart';
import 'package:yjg/bus/presentaion/widgets/bus_group_button.dart';
import 'package:yjg/bus/presentaion/widgets/bus_schedule_card.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';

class BusSchedule extends ConsumerWidget {
  const BusSchedule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(busViewModelProvider).fetchBusSchedules(0, 1, 's_bokhyun');

    return Scaffold(
      appBar: const BaseAppBar(title: '버스 시간표'),
      drawer: const BaseDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0),
            Text(
              '해당되는 버튼을 선택해주세요.',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Text(
                  '학기방학',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Palette.textColor.withOpacity(0.6),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10.0),
                BusGroupButton(dataType: 'semester'),
              ],
            ),
            Row(
              children: [
                Text(
                  '평일주말',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Palette.textColor.withOpacity(0.6),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10.0),
                BusGroupButton(dataType: 'weekend'),
              ],
            ),
            Row(
              children: [
                Text(
                  '기점선택',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Palette.textColor.withOpacity(0.6),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10.0),
                BusGroupButton(dataType: 'start'),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              '노선목록',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Consumer(builder: (context, ref, child) {
                final busSchedules =
                    ref.watch(busViewModelProvider).busSchedules;

                return busSchedules.when(
                  data: (schedules) {
                    // 데이터가 있는 경우 BusScheduleCard 위젯을 리스트로 렌더링
                    return ListView.builder(
                      itemCount: schedules.busRounds.length,
                      // BusSchedule 페이지 내 ListView.builder의 itemBuilder 부분
                      itemBuilder: (context, index) {
                        final busRound = schedules.busRounds[index];
                        return BusScheduleCard(busRound: busRound);
                      },
                    );
                  },
                  loading: () => Center(child: CircularProgressIndicator(color: Palette.stateColor4)), // 로딩 중 표시
                  error: (error, stack) => Text('에러가 발생했습니다.'), // 에러 발생 시 표시
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
