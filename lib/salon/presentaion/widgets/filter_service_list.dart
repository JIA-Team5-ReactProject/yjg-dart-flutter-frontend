import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:yjg/salon/presentaion/viewmodels/service_viewmodel.dart";
import "package:yjg/salon/presentaion/viewmodels/user_selection_viewmodel.dart";
import "package:yjg/shared/theme/palette.dart";
import 'package:intl/intl.dart';

class FilterServiceList extends ConsumerWidget {
  const FilterServiceList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 사용자 선택에 따른 고유 키 생성(.family는 인자로 고유키를 받음)
    final userSelection = ref.watch(userSelectionProvider);
    final selectedGender = userSelection.selectedGender; // 성별
    final selectedCategoryId = userSelection.selectedCategoryId;
    String uniqueKey = "${selectedGender}_${selectedCategoryId}";

    final servicesAsyncValue = ref.watch(servicesProvider(uniqueKey));

    return servicesAsyncValue.when(
      data: (services) => ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          final formattedPrice = NumberFormat('#,###', 'ko_KR')
                  .format(int.parse(service.price ?? '0')) +
              '원'; // 금액 포맷팅
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            margin: EdgeInsets.symmetric(vertical: 10.0),
            height: 70.0,
            decoration: BoxDecoration(
              color: Palette.backgroundColor,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey.shade300, width: 1.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  service.service ?? "Unknown Service",
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  formattedPrice,
                  style: TextStyle(color: Palette.mainColor),
                ),
              ],
            ),
          );
        },
      ),
      loading: () => Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: CircularProgressIndicator(
            color: Palette.stateColor4,
          ),
        ),
      ),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
