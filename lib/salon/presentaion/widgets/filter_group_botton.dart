import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/presentaion/viewmodels/category_viewmodel.dart';
import 'package:yjg/salon/presentaion/viewmodels/user_selection_viewmodel.dart';
import 'package:yjg/salon/presentaion/widgets/admin/add_category_modal.dart';
import 'package:yjg/salon/presentaion/widgets/admin/edit_category_modal.dart';

import 'package:yjg/shared/theme/palette.dart';

class FilterGroupButton extends ConsumerStatefulWidget {
  final String dataType;
  final uniqueKey;
  FilterGroupButton({Key? key, required this.dataType, required this.uniqueKey})
      : super(key: key);

  @override
  _FilterButtonsState createState() => _FilterButtonsState();
}

class _FilterButtonsState extends ConsumerState<FilterGroupButton> {
  int? _selectedButtonIndex;
  @override
  Widget build(BuildContext context) {
    final categoryDataAsyncValue = ref.watch(categoryListProvider);
    final userSelection = ref.watch(userSelectionProvider);

    return categoryDataAsyncValue.when(
      data: (Map<int, String> categoryData) {
        final categoryNames = categoryData.values.toList();
        List<String> buttons =
            widget.dataType == '성별' ? ['male', 'female'] : categoryNames;

        if (_selectedButtonIndex == null) {
          _selectedButtonIndex = widget.dataType == '성별'
              ? ['male', 'female'].indexOf(userSelection.selectedGender)
              : categoryData.keys
                  .toList()
                  .indexOf(userSelection.selectedCategoryId);
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 4.0, // 버튼 간 가로 간격 줄임
            runSpacing: 4.0, // 버튼 간 세로 간격 (Wrap이 여러 줄일 경우)
            children: List.generate(
              buttons.length,
              (index) => ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0)),
                  minimumSize: MaterialStateProperty.all<Size>(
                      Size(50, 30)), // 여기서 높이를 조정

                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (_selectedButtonIndex == index)
                        return Palette.mainColor; // 선택된 버튼 색상
                      return Colors.grey[300]!; // 기본 버튼 색상
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (_selectedButtonIndex == index)
                        return Colors.white; // 선택된 버튼 텍스트 색상
                      return Colors.grey[600]!; // 기본 버튼 텍스트 색상
                    },
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                onLongPress: () {
                  // 선택한 텍스트
                  final selectedText = buttons[index];
                  final int selectedCategoryId = categoryData.keys.elementAt(index);
                  widget.dataType == "유형"
                      ? editCategoryModal(selectedCategoryId, selectedText, context, ref)
                      : null;
                },
                onPressed: () {
                  setState(() {
                    _selectedButtonIndex = index;
                    // 선택 상태 업데이트 로직
                    if (widget.dataType == '성별') {
                      ref
                          .read(userSelectionProvider.notifier)
                          .setSelectedGender(buttons[index]);
                    } else {
                      ref
                          .read(userSelectionProvider.notifier)
                          .setSelectedCategoryId(
                              categoryData.keys.elementAt(index));
                    }
                  });
                },
                child: Text(
                  buttons[index],
                  style: TextStyle(fontSize: 13.0, letterSpacing: -0.5),
                ),
              ),
            ),
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
