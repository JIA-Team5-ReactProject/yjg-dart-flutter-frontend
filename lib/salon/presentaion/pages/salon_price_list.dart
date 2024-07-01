import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/presentaion/viewmodels/user_selection_viewmodel.dart';
import 'package:yjg/salon/presentaion/widgets/filter_group_botton.dart';
import 'package:yjg/salon/presentaion/widgets/filter_service_list.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';

class SalonPriceList extends ConsumerWidget {
  const SalonPriceList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSelection = ref.watch(userSelectionProvider);
    final selectedGender = userSelection.selectedGender;
    final selectedCategoryId = userSelection.selectedCategoryId;
    String uniqueKey = "${selectedGender}_${selectedCategoryId}";
    return Scaffold(
      appBar: BaseAppBar(
        title: 'salon.salonPriceList.title'.tr(),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      drawer: BaseDrawer(),
      body: CustomSingleChildScrollView(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  'salon.salonPriceList.PriceListPage.title1'.tr(),
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Text(
                      'salon.salonBooking.stepOne.filterText.gender'.tr(),
                      style:
                          TextStyle(color: Palette.textColor.withOpacity(0.7)),
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
                      style:
                          TextStyle(color: Palette.textColor.withOpacity(0.7)),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    FilterGroupButton(dataType: '유형', uniqueKey: uniqueKey)
                  ],
                ),
                SizedBox(
                  height: 40.0,
                ),
                Text(
                  'salon.salonPriceList.PriceListPage.title2'.tr(),
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                Text('salon.salonPriceList.PriceListPage.description'.tr(),
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Palette.textColor.withOpacity(0.7))),
                SizedBox(
                  height: 10.0,
                ),
                FilterServiceList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
