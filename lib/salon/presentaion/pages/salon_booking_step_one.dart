import 'package:flutter/material.dart';
import 'package:yjg/salon/presentaion/widgets/booking_service_button.dart';
import 'package:yjg/salon/presentaion/widgets/filter_group_botton.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';

class SalonBookingStepOne extends StatelessWidget {
  const SalonBookingStepOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: "미용실 예약"),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      drawer: const Drawer(),
      body: CustomSingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 12.0,
              ),
              Text(
                '1. 서비스를 선택해 주세요.',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12.0,
              ),
              Row(
                children: [
                  Text(
                    '성별',
                    style: TextStyle(color: Palette.textColor.withOpacity(0.7)),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  FilterGroupButton(dataType: '성별')
                ],
              ),
              SizedBox(
                height: 13.0,
              ),
              Row(
                children: [
                  Text(
                    '유형',
                    style: TextStyle(color: Palette.textColor.withOpacity(0.7)),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  FilterGroupButton(dataType: '유형')
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              BookingServiceButton(),
            ],
          ),
        ),
      ),
    );
  }
}
