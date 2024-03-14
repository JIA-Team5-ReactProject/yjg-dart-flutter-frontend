import 'package:flutter/material.dart';
import 'package:yjg/shared/theme/palette.dart';

void editServiceModal(BuildContext context,String serviceId, int? salonCategoryId, String price, String service) {
  TextEditingController nameController =
      TextEditingController(text: service);
  TextEditingController priceController =
      TextEditingController(text: price.toString());

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '서비스 수정',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: '서비스명',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: '가격'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // 버튼들 사이에 공간을 최대한 분배
              children: [
                TextButton(
                  child: Text(
                    '서비스 삭제',
                    style: TextStyle(
                        color: Palette.stateColor3,
                        letterSpacing: -1.0,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    // 삭제 로직 구현
                    Navigator.pop(context); // 모달 닫기
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    // 완료 버튼 로직
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.mainColor,
                    elevation: 0, // 쉐도우 제거
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
}
