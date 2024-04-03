import 'package:yjg/salon/data/data_sources/admin/admin_category_data_source.dart';
import 'package:yjg/salon/domain/entities/category.dart';

class CategoryResult {
  final bool isSuccess;
  final String message;

  CategoryResult({required this.isSuccess, required this.message});
}

class CategoryUseCases {
  final AdminCategoryDataSource dataSource;

  CategoryUseCases(this.dataSource);

  Future<CategoryResult> createCategory(SalonCategory category) async {
    try {
      final response = await dataSource.postCategoryAPI(
        category.categoryName!,
      );

      if (response.statusCode == 201) {
        return CategoryResult(isSuccess: true, message: '서비스가 성공적으로 생성되었습니다.');
      } else {
        return CategoryResult(
            isSuccess: false, message: '서비스 생성 실패: ${response.data}');
      }
    } catch (e) {
      return CategoryResult(isSuccess: false, message: '서비스 생성 중 에러 발생: $e');
    }
  }

  Future<CategoryResult> updateCategory(SalonCategory category) async {
    try {
      final response = await dataSource.patchCategoryAPI(
        category.categoryId!,
        category.categoryName,
      );

      if (response.statusCode == 200) {
        return CategoryResult(
            isSuccess: true, message: '카테고리 성공적으로 업데이트되었습니다.');
      } else {
        return CategoryResult(
            isSuccess: false, message: '카테고리 수정 실패: ${response.data}');
      }
    } catch (e) {
      return CategoryResult(isSuccess: false, message: '카테고리 수정 중 에러 발생: $e');
    }
  }

  Future<CategoryResult> deleteCategory(SalonCategory category) async {
    try {
      final response = await dataSource.deleteCategoryAPI(
        category.categoryId!,
      );

      if (response.statusCode == 200) {
        return CategoryResult(isSuccess: true, message: '카테고리가 성공적으로 삭제되었습니다.');
      } else {
        return CategoryResult(
            isSuccess: false, message: '카테고리 삭제 실패: ${response.data}');
      }
    } catch (e) {
      return CategoryResult(isSuccess: false, message: '카테고리 삭제 중 에러 발생: $e');
    }
  }
}
