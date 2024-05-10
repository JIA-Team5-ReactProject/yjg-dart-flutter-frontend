import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/presentaion/widgets/booking_calendar.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';

class SalonBookingStepTwo extends ConsumerWidget {
  const SalonBookingStepTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: BaseAppBar(title: "미용실 예약"),
      drawer: BaseDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: CustomSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 12.0,
              ),
              Text('2. 예약 날짜를 선택해 주세요.',
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              BookingCalendar(),
            ],
          ),
        ),
      ),
    );
  }
}
