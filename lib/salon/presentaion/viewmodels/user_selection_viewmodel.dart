import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSelectionState {
  final int selectedCategoryId;
  final String selectedGender;

  UserSelectionState({this.selectedCategoryId = 0, this.selectedGender = ''});

  UserSelectionState copyWith({int? selectedCategoryId, String? selectedGender}) {
    return UserSelectionState(
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedGender: selectedGender ?? this.selectedGender,
    );
  }

  // toSting 메서드 오버라이딩 안 하면 출력했을 때 Instance of 'UserSelectionState'라고 뜨니 오버라이딩
  @override
  String toString() {
    return 'UserSelectionState(selectedCategoryId: $selectedCategoryId, selectedGender: "$selectedGender")';
  }

}

class UserSelectionNotifier extends StateNotifier<UserSelectionState> {
  UserSelectionNotifier() : super(UserSelectionState());

  void setSelectedCategoryId(int categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId);
  }

  void setSelectedGender(String gender) {
    state = state.copyWith(selectedGender: gender);
  }
}

final userSelectionProvider = StateNotifierProvider<UserSelectionNotifier, UserSelectionState>((ref) {
  return UserSelectionNotifier();
});
