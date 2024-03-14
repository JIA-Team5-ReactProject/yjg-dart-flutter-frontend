import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:dotted_line/dotted_line.dart";
import 'package:yjg/shared/service/auth_service.dart';
import 'package:yjg/shared/theme/palette.dart';

// BaseDrawer를 ConsumerWidget으로 변환
class BaseDrawer extends ConsumerWidget {
  const BaseDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AuthService 인스턴스 생성
    final authService = AuthService();

    Future<void> checkUserState() async {
      if (!(await authService.isLoggedIn())) {
        debugPrint('토큰 미존재. 로그인 페이지로 이동');
        Navigator.pushNamed(context, '/login_student');
      } else {
        debugPrint('로그인 중');
      }
    }

    // initState 대신, ConsumerWidget에서는 addPostFrameCallback 내에서 직접 호출
    WidgetsBinding.instance.addPostFrameCallback((_) => checkUserState());

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
            onTap: () =>
                authService.logout(context, ref), // onTap 이벤트를 직접 logout 함수 호출로 변경
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
