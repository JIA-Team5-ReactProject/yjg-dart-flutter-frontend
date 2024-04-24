import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/bus/presentaion/viewmodels/bus_viewmodel.dart';
import 'package:yjg/bus/presentaion/widgets/bus_group_button.dart';
import 'package:yjg/bus/presentaion/widgets/bus_schedule_card.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';

class BusSchedule extends ConsumerStatefulWidget {
  const BusSchedule({super.key});

  @override
  _BusScheduleState createState() => _BusScheduleState();
}

class _BusScheduleState extends ConsumerState<BusSchedule> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(busViewModelProvider).fetchBusSchedules(0, 1, 's_bokhyun'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: '버스 시간표'),
      drawer: BaseDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),
            const Text(
              '해당되는 버튼을 선택해주세요.',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Text(
                  '학기방학',
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Palette.textColor.withOpacity(0.6),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10.0),
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
                const SizedBox(width: 10.0),
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
                const SizedBox(width: 10.0),
                BusGroupButton(dataType: 'start'),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text(
              '노선목록',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: Consumer(builder: (context, ref, child) {
                final busSchedules =
                    ref.watch(busViewModelProvider).busSchedules;

                return busSchedules.when(
                  data: (schedules) => ListView.builder(
                    itemCount: schedules.busRounds.length,
                    itemBuilder: (context, index) {
                      final busRound = schedules.busRounds[index];
                      return BusScheduleCard(busRound: busRound);
                    },
                  ),
                  loading: () => const Center(
                      child: CircularProgressIndicator(
                          color: Palette.stateColor4)),
                  error: (error, stack) => const Text('에러가 발생했습니다.'),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
