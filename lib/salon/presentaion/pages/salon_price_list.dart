import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/data/data_sources/price_data_source.dart';
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
    return Scaffold(
      appBar: BaseAppBar(
        title: '가격표',
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      drawer: const BaseDrawer(),
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
                  '필터 설정',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Text(
                      '성별',
                      style:
                          TextStyle(color: Palette.textColor.withOpacity(0.7)),
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
                      style:
                          TextStyle(color: Palette.textColor.withOpacity(0.7)),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    FilterGroupButton(dataType: '유형')
                  ],
                ),
                SizedBox(
                  height: 40.0,
                ),
                Text(
                  '서비스 목록',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                Text('서비스와 가격은 변경될 수 있습니다.', style: TextStyle(fontSize: 12.0, color: Palette.textColor.withOpacity(0.7))),
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
