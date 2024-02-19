import 'package:flutter/material.dart';
import 'package:yjg/salon(admin)/presentation/widgets/edit_service_modal.dart';
import 'package:yjg/shared/theme/palette.dart';

class ServiceTabbar extends StatefulWidget {
  @override
  _ServiceTabbar createState() => _ServiceTabbar();
}

class _ServiceTabbar extends State<ServiceTabbar>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<Map<String, dynamic>> _cutServices = [
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

  final List<Map<String, dynamic>> _permServices = [
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

  final List<Map<String, dynamic>> _colorServices = [
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
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Widget _buildServiceList(List<Map<String, dynamic>> services) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.93,
      child: ListView.builder(
        itemCount: services.length,
        padding: EdgeInsets.only(top: 15.0),
        itemBuilder: (context, index) {
          final service = services[index];
          return InkWell(
            onTap: () => editServiceModal(context, service),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              margin: EdgeInsets.symmetric(vertical: 7.0),
              height: 70.0,
              decoration: BoxDecoration(
                color: Palette.backgroundColor,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    service['name'],
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    '${service['price']}원',
                    style: TextStyle(color: Palette.mainColor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: '컷트'),
              Tab(text: '펌'),
              Tab(text: '염색'),
            ],
          ),
          SizedBox(height: 20.0),
          Text(
            '항목을 선택하면 수정이 가능합니다.',
            style: TextStyle(color: Palette.stateColor3),
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: _buildServiceList(_cutServices),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: _buildServiceList(_permServices),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: _buildServiceList(_colorServices),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
