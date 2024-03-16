import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:yjg/salon/presentaion/viewmodels/category_viewmodel.dart";
import "package:yjg/shared/theme/palette.dart";

class CategoryDropdown extends ConsumerWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const CategoryDropdown({
    Key? key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryDataAsyncValue = ref.watch(categoryListProvider);
    return categoryDataAsyncValue.when(
      data: (categories) {
        final categoryItems = categories.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key.toString(),
            child: Text(entry.value),
          );
        }).toList();

        return DropdownButton<String>(
          value: selectedCategory,
          onChanged: (value) => onCategoryChanged(value!),
          items: categoryItems,
          alignment: Alignment.centerLeft,
          style: TextStyle(color: Palette.textColor),
          underline: Container(
            height: 1.5,
            color: Palette.textColor.withOpacity(0.4),
          ),
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
