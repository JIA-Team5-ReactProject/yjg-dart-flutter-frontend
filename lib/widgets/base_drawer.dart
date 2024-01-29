import "package:dotted_line/dotted_line.dart";
import "package:flutter/material.dart";
import "package:yjg/theme/pallete.dart";

class BaseDrawer extends StatelessWidget {
  const BaseDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(top: 0.0), // 상단 패딩 제거
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/img/yju_tiger_logo.png'),
            ),
            accountName: const Text('김영진'), // TODO: 추후 통신
            accountEmail: const Text('2201333'),
            decoration: const BoxDecoration(
              color: Pallete.mainColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              '버스',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            iconColor: Pallete.mainColor,
            focusColor: Pallete.mainColor,
            title: const Text('시간표'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: DottedLine(
              dashColor: Pallete.stateColor4,
              dashLength: 2,
              lineLength: double.infinity, // 길이 조절
              lineThickness: 2, // 두께 조절
            ),
          ),

          // ! 식수
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              '식수',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.table_chart_outlined),
            iconColor: Pallete.mainColor,
            focusColor: Pallete.mainColor,
            title: const Text('식단표'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.event),
            iconColor: Pallete.mainColor,
            focusColor: Pallete.mainColor,
            title: const Text('주말 식수'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: DottedLine(
              dashColor: Pallete.stateColor4,
              dashLength: 2,
              lineLength: double.infinity, // 길이 조절
              lineThickness: 2, // 두께 조절
            ),
          ),

          // ! 미용실
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              '미용실',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_task),
            iconColor: Pallete.mainColor,
            focusColor: Pallete.mainColor,
            title: const Text('예약'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.content_paste_search),
            iconColor: Pallete.mainColor,
            focusColor: Pallete.mainColor,
            title: const Text('가격표'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: DottedLine(
              dashColor: Pallete.stateColor4,
              dashLength: 2,
              lineLength: double.infinity, // 길이 조절
              lineThickness: 2, // 두께 조절
            ),
          ),

          // ! 행정
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              '행정',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.campaign_outlined),
            iconColor: Pallete.mainColor,
            focusColor: Pallete.mainColor,
            title: const Text('공지사항'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.construction),
            iconColor: Pallete.mainColor,
            focusColor: Pallete.mainColor,
            title: const Text('AS 요청'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.work_history_outlined),
            iconColor: Pallete.mainColor,
            focusColor: Pallete.mainColor,
            title: const Text('외박/외출 신청'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.groups_outlined),
            iconColor: Pallete.mainColor,
            focusColor: Pallete.mainColor,
            title: const Text('회의실 예약'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
