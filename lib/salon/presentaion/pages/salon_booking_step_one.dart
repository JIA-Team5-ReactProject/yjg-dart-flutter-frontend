import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/presentaion/viewmodels/user_selection_viewmodel.dart';
import 'package:yjg/salon/presentaion/widgets/booking_service_button.dart';
import 'package:yjg/salon/presentaion/widgets/filter_group_botton.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';

class SalonBookingStepOne extends ConsumerWidget {
  const SalonBookingStepOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSelection = ref.watch(userSelectionProvider);
    final selectedGender = userSelection.selectedGender;
    final selectedCategoryId = userSelection.selectedCategoryId;
    String uniqueKey = "${selectedGender}_${selectedCategoryId}";

    return Scaffold(
      appBar: BaseAppBar(title: "salon.salonBooking.title".tr()),
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
              Text(
                'salon.salonBooking.stepOne.description1'.tr(),
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12.0,
              ),
              Row(
                children: [
                  Text(
                    'salon.salonBooking.stepOne.filterText.gender'.tr(),
                    style: TextStyle(color: Palette.textColor.withOpacity(0.7)),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  FilterGroupButton(dataType: '성별', uniqueKey: uniqueKey)
                ],
              ),
              Row(
                children: [
                  Text(
                    'salon.salonBooking.stepOne.filterText.type'.tr(),
                    style: TextStyle(color: Palette.textColor.withOpacity(0.7)),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  FilterGroupButton(dataType: '유형', uniqueKey: uniqueKey)
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              BookingServiceButton(),
            ],
          ),
        ),
      ),
    );
  }
}
