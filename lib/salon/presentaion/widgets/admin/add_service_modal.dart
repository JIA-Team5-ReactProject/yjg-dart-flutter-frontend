import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/data/data_sources/admin/admin_service_data_source.dart';
import 'package:yjg/salon/domain/entities/service.dart';
import 'package:yjg/salon/domain/usecases/admin_service_usecase.dart';
import 'package:yjg/salon/presentaion/viewmodels/service_viewmodel.dart';
import 'package:yjg/salon/presentaion/widgets/admin/category_dropdown.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';

void addServiceModal(BuildContext context, WidgetRef ref, String uniqueKey) {
  final serviceUseCases = ServiceUseCases(AdminServiceDataSource());

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String selectedGender = 'male'; // 초기 성별 값
  String selectedCategory = '1'; // 초기 카테고리 값

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        // StatefulBuilder를 사용하여 상태를 관리
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            padding: EdgeInsets.only(left: 20, right: 20, top: 30),
            child: CustomSingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '서비스 등록',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '모든 항목을 입력해주세요.',
                    style: TextStyle(
                        color: Palette.textColor.withOpacity(0.7),
                        fontSize: 14),
                  ),
                  SizedBox(height: 20),
                  Text('카테고리',
                      style: TextStyle(
                          fontSize: 16,
                          color: Palette.textColor.withOpacity(0.7))),
                  SizedBox(width: 10),
                  CategoryDropdown(
                    selectedCategory: selectedCategory,
                    onCategoryChanged: (newValue) {
                      setState(() {
                        selectedCategory = newValue;
                        debugPrint('카테고리: $selectedCategory');
                      });
                    },
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: '서비스명',
                      labelStyle: TextStyle(
                        color: Palette.textColor.withOpacity(0.7),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Palette.mainColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: '가격',
                      labelStyle: TextStyle(
                        color: Palette.textColor.withOpacity(0.7),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Palette.mainColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: const Text('Male'),
                          horizontalTitleGap: 0,
                          leading: Radio<String>(
                            value: 'male',
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            },
                            activeColor: Palette.mainColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('Female'),
                          horizontalTitleGap: 0,
                          leading: Radio<String>(
                            value: 'female',
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value!;
                                debugPrint('성별: $selectedGender ');
                              });
                            },
                            activeColor: Palette.mainColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end, // 완료 버튼을 오른쪽으로 정렬
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            // 사용자 입력값을 바탕으로 Service 엔티티 생성
                            Service newService = Service(
                              categoryId: int.parse(selectedCategory),
                              serviceName: nameController.text,
                              gender: selectedGender,
                              price: priceController.text,
                            );

                            // createService 메소드를 호출하여 서비스 추가
                            ServiceResult result =
                                await serviceUseCases.createService(newService);

                            if (result.isSuccess) {
                              // 성공 시 서비스 리스트 상태 업데이트
                              ref.refresh(servicesProvider(uniqueKey));

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
                            '서비스 등록',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
