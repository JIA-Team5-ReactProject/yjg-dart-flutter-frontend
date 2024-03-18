import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/data/data_sources/admin/admin_category_data_source.dart';
import 'package:yjg/salon/domain/entities/category.dart';
import 'package:yjg/salon/domain/usecases/admin_category_usecase.dart';
import 'package:yjg/salon/presentaion/viewmodels/category_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';

void editCategoryModal(
  int? salonCategoryId,
  String salonCategoryName,
  BuildContext context,
  WidgetRef ref,
) {
  TextEditingController categoryController =
      TextEditingController(text: salonCategoryName);
  final categoryUseCases = CategoryUseCases(AdminCategoryDataSource());

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        // StatefulBuilder를 사용하여 상태를 관리
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.32,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '카테고리 수정',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '수정할 카테고리명을 입력해주세요.',
                  style: TextStyle(
                      color: Palette.textColor.withOpacity(0.7), fontSize: 14),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: '카테고리명',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Palette.mainColor),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Text(
                        '카테고리 삭제',
                        style: TextStyle(
                            color: Palette.stateColor3,
                            letterSpacing: -1.0,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        SalonCategory deleteCategory = SalonCategory(
                          categoryId: salonCategoryId,
                        );

                        CategoryResult result = await categoryUseCases
                            .deleteCategory(deleteCategory);

                        if (result.isSuccess) {
                          // 성공 시 서비스 리스트 상태 업데이트
                          ref.refresh(categoryListProvider);

                          // 성공 알림 표시
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result.message),
                              backgroundColor: Palette.mainColor,
                            ),
                          );

                          // 모달 창 닫기
                          Navigator.pop(context);
                        } else {
                          // 실패 시 실패 알림 표시
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        SalonCategory updateCategory = SalonCategory(
                          categoryName: categoryController.text,
                          categoryId: salonCategoryId,
                        );

                        CategoryResult result = await categoryUseCases
                            .updateCategory(updateCategory);

                        if (result.isSuccess) {
                          // 성공 시 서비스 리스트 상태 업데이트
                          ref.refresh(categoryListProvider);

                          // 성공 알림 표시
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result.message),
                              backgroundColor: Palette.mainColor,
                            ),
                          );

                          // 모달 창 닫기
                          Navigator.pop(context);
                        } else {
                          // 실패 시 실패 알림 표시
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.mainColor,
                        elevation: 0,
                      ),
                      child: Text(
                        '완료',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30)
              ],
            ),
          );
        },
      );
    },
  );
}
