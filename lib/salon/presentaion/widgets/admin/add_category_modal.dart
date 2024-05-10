import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/data/data_sources/admin/admin_category_data_source.dart';
import 'package:yjg/salon/domain/entities/category.dart';
import 'package:yjg/salon/domain/usecases/admin_category_usecase.dart';
import 'package:yjg/salon/presentaion/viewmodels/category_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';

void addCategoryModal(BuildContext context, WidgetRef ref, String uniqueKey) {
  final categoryUseCases = CategoryUseCases(AdminCategoryDataSource());

  TextEditingController categoryController = TextEditingController();

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        // StatefulBuilder를 사용하여 상태를 관리
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.35,
            padding: EdgeInsets.only(left: 20, right: 20, top: 30),
            child: CustomSingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '카테고리 등록',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '등록할 카테고리명을 입력해주세요. (성별 추가 불가)',
                    style: TextStyle(
                        color: Palette.textColor.withOpacity(0.7),
                        fontSize: 14),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: categoryController,
                    decoration: InputDecoration(
                      labelText: '카테고리명',
                      labelStyle: TextStyle(
                        color: Palette.textColor.withOpacity(0.7),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Palette.mainColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end, // 완료 버튼을 오른쪽으로 정렬
                    children: [
                      Expanded(
                        child: ElevatedButton( 
                          onPressed: () async {
                            print(categoryController.text);
                            SalonCategory newCategory = SalonCategory(
                              categoryName: categoryController.text,
                            );

                            CategoryResult result = await categoryUseCases
                                .createCategory(newCategory);

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
                            '카테고리 등록',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40)
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
