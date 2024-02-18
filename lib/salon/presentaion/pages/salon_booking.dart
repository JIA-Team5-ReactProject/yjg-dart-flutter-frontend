import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:yjg/salon(admin)/presentation/widgets/booking_calendar.dart';
import 'package:yjg/salon/presentaion/widgets/booking_next_button.dart';
import 'package:yjg/salon/presentaion/widgets/date_button.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';

class SalonBooking extends StatelessWidget {
  const SalonBooking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: "미용실 예약"),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      drawer: const Drawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BookingCalendar(),
            SizedBox(height: 20),
            DottedLine(
              dashColor: Palette.stateColor4,
              dashLength: 2,
              lineLength: MediaQuery.of(context).size.width * 0.95,
              lineThickness: 1,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('오전'),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      for (int i = 0; i < 3; i++)
                        DateButton(time: '${10 + i}:00'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('오후'),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      for (int i = 0; i < 8; i++)
                        DateButton(time: '${13 + i}:00'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BookingNextButton(),
                SizedBox(width: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
