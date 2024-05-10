import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/data/data_sources/price_data_source.dart';
import 'package:yjg/salon/data/models/service.dart';
import 'package:yjg/salon/presentaion/viewmodels/user_selection_viewmodel.dart';

// .family: 동적인 인자를 받을 수 있음, 같은 타입의 여러 값을 가진 프로바이더 생성
// 인자: 사용자 선택을 식별하는 데에 사용되는 고유키
final servicesProvider = FutureProvider.autoDispose
    .family<List<Services>, String>((ref, userSelectionKey) async {
  // userSelectionProvider를 통해 사용자 선택 정보 가져오기(user_selection_viewmodel.dart 참고)
  final userSelection = ref.watch(userSelectionProvider);
  final selectedGender = userSelection.selectedGender; // 성별
  final selectedCategoryId = userSelection.selectedCategoryId; // 카테고리 아이디
  if (selectedGender.isNotEmpty && selectedCategoryId != null) {
    // API body에 들어갈 두 값이 빈 값이 아닐 경우
    final dataSource = PriceDataSource(); // PriceDataSource 생성

    // getServiceListAPI 호출 결과가 Map<String, dynamic>이므로 직접 사용
    final Map<String, dynamic> response = await dataSource.getServiceListAPI(
        selectedGender, selectedCategoryId); // API 호출

    final serviceData = Servicegenerated.fromJson(response); // Dart 객체로 변환

    return serviceData.services ?? []; // 서비스 목록이 null일 경우 빈 리스트를 반환
  }
  return []; // 선택 성별, id 유효하지 않음 -> 빈 리스트 반환
});
