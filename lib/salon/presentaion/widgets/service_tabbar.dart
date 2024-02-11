import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceTabBar extends StatefulWidget {
  @override
  _ServiceTabBarState createState() => _ServiceTabBarState();
}

class _ServiceTabBarState extends State<ServiceTabBar> {
  // 각 탭의 선택된 서비스를 추적하는 변수
  int? _selectedCutService;
  int? _selectedPermService;
  int? _selectedDyeService;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          TabBar(
            tabs: [
              Tab(text: '컷트'),
              Tab(text: '펌'),
              Tab(text: '염색'),
            ],
          ),
          SizedBox(
            height: 730.0,
            child: TabBarView(
              children: [
                buildServiceList('컷트'),
                buildServiceList('펌'),
                buildServiceList('염색'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildServiceList(String category) {
    final services = getServicesByCategory(category);
    return ListView.builder(
      // shrinkWrap: true, // 추가된 부분: ListView의 크기를 내용에 맞게 조정
      // physics: NeverScrollableScrollPhysics(), // 추가된 부분: ListView 내 스크롤 방지
      itemCount: services.length,
      itemBuilder: (context, index) {
        // 서비스 이름과 가격을 결합하여 표시
        final serviceName = services[index]['name'] as String;
        final servicePrice = services[index]['price'] as int; // 가격 정보
        final serviceInfo =
            "$serviceName (${NumberFormat('###,###', 'ko_KR').format(servicePrice)}원)"; // 가격을 포맷팅하여 결합

        return ListTile(
          title: Text(serviceInfo), // 수정된 부분
          trailing: Radio(
            value: index,
            groupValue: getCategorySelectedService(category),
            onChanged: (int? value) {
              onServiceSelected(category, value);
            },
          ),
          onTap: () {
            onServiceSelected(category, index);
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> getServicesByCategory(String category) {
    switch (category) {
      case '컷트':
        return [
          {"name": "컷트(남)", "price": 10000},
          {"name": "재학생(남)", "price": 10000},
          {"name": "컷트+옆다운(남)", "price": 15000},
          {"name": "컷트+옆다운+뒷다운(남)", "price": 20000},
          {"name": "컷트+전체다운(남)", "price": 25000},
          {"name": "면접헤어(남)", "price": 10000},
          {"name": "앞머리(여)", "price": 2000},
          {"name": "단발컷(여)", "price": 8000},
          {"name": "숏컷(여)", "price": 10000},
          {"name": "디자인컷(여)", "price": 10000},
          {"name": "레이어드컷(여)", "price": 10000},
          {"name": "허쉬컷(여)", "price": 10000},
          {"name": "보브단발(여)", "price": 10000},
        ];
      case '펌':
        return [
          {"name": "컷트+댄디펌(남)", "price": 30000},
          {"name": "컷트+애즈펌(남)", "price": 30000},
          {"name": "컷트+쉐도우펌(남)", "price": 30000},
          {"name": "컷트+포마드펌(남)", "price": 30000},
          {"name": "컷트+리프펌(남)", "price": 35000},
          {"name": "컷트+스왈로펌(남)", "price": 40000},
          {"name": "컷트+펌+옆다운(남)", "price": 35000},
          {"name": "컷트+펌+옆+뒷다운(남)", "price": 40000},
          {"name": "컷트+볼륨매직(남)", "price": 45000},
          {"name": "재학생 외 펌(남)", "price": 35000},
          {"name": "단발펌(여)", "price": 40000},
          {"name": "매직(여)", "price": 50000},
          {"name": "디지털(여)", "price": 55000},
          {"name": "볼륨매직(여)", "price": 60000},
          {"name": "물결펌(여)", "price": 60000},
          {"name": "매직셋팅(여)", "price": 70000},
        ];
      case '염색':
        return [
          {"name": "컷트(남)", "price": 10000},
          {"name": "재학생(남)", "price": 10000},
          {"name": "컷트+옆다운(남)", "price": 15000},
          {"name": "컷트+옆다운+뒷다운(남)", "price": 20000},
          {"name": "컷트+전체다운(남)", "price": 25000},
          {"name": "면접헤어(남)", "price": 10000},
          {"name": "앞머리(여)", "price": 2000},
          {"name": "단발컷(여)", "price": 8000},
          {"name": "숏컷(여)", "price": 10000},
          {"name": "디자인컷(여)", "price": 10000},
          {"name": "레이어드컷(여)", "price": 10000},
          {"name": "허쉬컷(여)", "price": 10000},
          {"name": "보브단발(여)", "price": 10000},
        ];
      default:
        return [];
    }
  }

  void onServiceSelected(String category, int? index) {
    setState(() {
      switch (category) {
        case '컷트':
          _selectedCutService = index;
          break;
        case '펌':
          _selectedPermService = index;
          break;
        case '염색':
          _selectedDyeService = index;
          break;
      }
    });
  }

  int? getCategorySelectedService(String category) {
    switch (category) {
      case '컷트':
        return _selectedCutService;
      case '펌':
        return _selectedPermService;
      case '염색':
        return _selectedDyeService;
      default:
        return null;
    }
  }
}
