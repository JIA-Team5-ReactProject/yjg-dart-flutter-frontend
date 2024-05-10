import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/data/data_sources/price_data_source.dart';
import 'package:yjg/salon/data/models/category.dart';

// `FutureProvider.autoDispose` : 비동기 로직을 처리하는 Riverpod 프로바이더, 위젯 트리에서 참조 안되면 자동으로 메모리를 해제
final categoryListProvider =
    FutureProvider.autoDispose<Map<int, String>>((ref) async {
  final priceDataSource = PriceDataSource();

  final response = await priceDataSource.getCategoryListAPI();

  if (response.statusCode == 200) {
    // response.body를 JSON 형태로 디코드, CategoryGenerated 인스턴스 변환, categoryGenerated에 저장
    final categoryGenerated =
        Categorygenerated.fromJson(response.data);

    // Key: 카테고리 id, Value: 카테고리 이름
    Map<int, String> categoryMap = {};

    // categoryGenerated 객체의 categories 리스트 돌면서 각 카테고리의 id와 이름을 categoryMap에 추가
    for (var element in categoryGenerated.categories!) {
      categoryMap[element.id!] = element.category!;
    }

    return categoryMap;
  } else {
    throw Exception('카테고리 데이터를 불러오는데 실패했습니다.');
  }
});

// 카테고리 상태 업데이트를 위한 UserIdProvider
class CategoryNotifier extends StateNotifier<Map<int, String>> {
  CategoryNotifier() : super({}); // 초기값 null

  void setCategoryState(Map<int, String> category) {
    state = category;
  }
}

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, Map<int, String>>((ref) {
  return CategoryNotifier();
});
