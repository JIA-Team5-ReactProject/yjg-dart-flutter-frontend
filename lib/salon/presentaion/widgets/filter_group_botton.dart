import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_button/group_button.dart';
import 'package:yjg/salon/presentaion/viewmodels/category_viewmodel.dart';
import 'package:yjg/salon/presentaion/viewmodels/user_selection_viewmodel.dart';

import 'package:yjg/shared/theme/palette.dart';

class FilterGroupButton extends ConsumerWidget {
  FilterGroupButton({Key? key, required this.dataType}) : super(key: key);
  final String dataType;
  List<String> genderData = ['male', 'female'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 비동기 데이터 로드
    final categoryDataAsyncValue = ref.watch(categoryListProvider);
    final userSelection = ref.watch(userSelectionProvider);

    // AsyncValue: 데이터가 로드중인지, 성공적으로 로드됐는지, 오류 발생했는지 등 다양한 상태를 나타내는 객체
    // .when(): AsyncValue의 상태에 따라 다른 위젯을 표시(data, loading, error)
    return categoryDataAsyncValue.when(
      data: (Map<int, String> categoryData) {
        // 데이터 로드 성공 시, UI 구성
        final categoryNames = categoryData.values.toList();
        final buttons = dataType == '성별' ? genderData : categoryNames;

        // 기본 선택 인덱스 계산
        int defaultSelectedIndex = dataType == '성별'
            ? genderData.indexOf(userSelection.selectedGender)
            : categoryData.keys
                .toList()
                .indexOf(userSelection.selectedCategoryId);

        // GroupButtonController 초기화
        final controller = GroupButtonController(
          selectedIndex: defaultSelectedIndex,
        );

        return GroupButton(
          isRadio: true,
          buttons: buttons,
          onSelected: (val, i, selected) {
            if (dataType == '성별') {
              // 성별 선택을 상태로 저장
              ref.read(userSelectionProvider.notifier).setSelectedGender(val);
            } else {
              // 카테고리 선택의 경우, val이 카테고리 이름이므로, 이를 id로 변환해야 함(카테고리 이름으로 카테고리 ID 찾기)
              int? categoryId = categoryData.keys
                  .firstWhere((k) => categoryData[k] == val, orElse: () => -1);
              if (categoryId != null) {
                // 유효한 카테고리 ID가 있다면 상태 업데이트
                ref
                    .read(userSelectionProvider.notifier)
                    .setSelectedCategoryId(categoryId);
              }
              debugPrint(ref.read(userSelectionProvider).toString());
            }
          },
          controller: controller,
          options: GroupButtonOptions(
            buttonWidth: 65.0,
            buttonHeight: 25.0,
            unselectedColor: Colors.grey[300],
            unselectedTextStyle: TextStyle(
              color: Colors.grey[600],
            ),
            selectedColor: Palette.mainColor,
            elevation: 0,
            selectedTextStyle: TextStyle(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
        );
      },
      loading: () => SizedBox(
        width: 20,
        height: 20,
        child: const CircularProgressIndicator(color: Palette.stateColor4),
      ),
      error: (e, stack) => Text('Error: $e'),
    );
  }
}
