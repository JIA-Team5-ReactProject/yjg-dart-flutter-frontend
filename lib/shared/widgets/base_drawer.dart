import "package:dotted_line/dotted_line.dart";
import "package:flutter/material.dart";
import 'package:yjg/shared/theme/palette.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // flutter_secure_storage 패키지

class BaseDrawer extends StatefulWidget {
  const BaseDrawer({Key? key}) : super(key: key);

  @override
  State<BaseDrawer> createState() => _BaseDrawerState();
}

class _BaseDrawerState extends State<BaseDrawer> {
  static final storage = FlutterSecureStorage();
  dynamic userInfo = '';

  // 로그아웃

  logout() async {
    await storage.delete(key: 'auth_token');
    debugPrint('로그아웃 완료');
    if (mounted) {
      // 현재 위젯이 아직 마운트되어 있는지 확인
      Navigator.pushNamed(context, '/login_domestic');
    }
  }

  checkUserState() async {
    userInfo = await storage.read(key: 'auth_token');
    if (userInfo == null) {
      debugPrint('토큰 미존재. 로그인 페이지로 이동');
      if (mounted) {
        // 현재 위젯이 아직 마운트되어 있는지 확인
        Navigator.pushNamed(context, '/login_domestic');
      } // 로그인 페이지로 이동
    } else {
      debugPrint('로그인 중');
    }
  }

  @override
  void initState() {
    super.initState();

    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserState();
    });
  }

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
            accountName: const Text('김영진'), // ! 추후 통신
            accountEmail: const Text('2201333'),
            decoration: const BoxDecoration(
              color: Palette.mainColor,
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
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title: const Text('시간표'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: DottedLine(
              dashColor: Palette.stateColor4,
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
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title: const Text('식단표'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.event),
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title: const Text('주말 식수'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: DottedLine(
              dashColor: Palette.stateColor4,
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
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title: const Text('예약'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.content_paste_search),
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title: const Text('가격표'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: DottedLine(
              dashColor: Palette.stateColor4,
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
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title: const Text('공지사항'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.construction),
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title: const Text('AS 요청'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.work_history_outlined),
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title: const Text('외박/외출 신청'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.groups_outlined),
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title: const Text('회의실 예약'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {},
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: DottedLine(
              dashColor: Palette.stateColor4,
              dashLength: 2,
              lineLength: double.infinity, // 길이 조절
              lineThickness: 2, // 두께 조절
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            iconColor: Palette.stateColor3,
            focusColor: Palette.stateColor3,
            title: const Text(
              '로그아웃',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              logout();
            },
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
