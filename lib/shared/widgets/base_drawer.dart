import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:dotted_line/dotted_line.dart";
import 'package:yjg/shared/service/logout_service.dart';
import 'package:yjg/shared/service/user_info.dart';
import 'package:yjg/shared/theme/palette.dart';

class BaseDrawer extends ConsumerStatefulWidget {
  BaseDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BaseDrawerState();
}

class _BaseDrawerState extends ConsumerState<BaseDrawer> {
  String? name;
  String? studenNum; // 학번

  @override
  void initState() {
    loadUserInfo();
    super.initState();
  }

  Future<void> loadUserInfo() async {
    final userInfo = await UserInfo.getUserInfo();
    setState(() {
      name = userInfo['name'];
      studenNum = userInfo['studentNum'];
    });
  }

  // AuthService 인스턴스 생성
  final logoutService = LogoutService();

  Future<void> checkUserState() async {
    if (!(await logoutService.isLoggedIn())) {
      debugPrint('토큰 미존재. 로그인 페이지로 이동');
      Navigator.pushNamed(context, '/login_student');
    } else {
      debugPrint('로그인 중');
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => checkUserState());

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(top: 0.0), // 상단 패딩 제거
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/img/yju_tiger_logo.png'),
            ),
            accountName: Text(name ?? '정보 없음'),
            accountEmail: Text(studenNum ?? '정보 없음'),
            decoration: const BoxDecoration(
              color: Palette.mainColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              "drawer.bus.title".tr(),
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title: Text('drawer.bus.busSchedule'.tr()),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.pop(context); //drawer 닫기
              Navigator.of(context)
                  .popUntil((route) => route.isFirst); //열린 창 다 닫고 첫 페이지(홈) 이동
              Navigator.pushNamed(context, '/bus_schedule'); // 원하는 페이지 이동
            },
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
          Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              'drawer.restaurant.title'.tr(),
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.table_chart_outlined),
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title: Text('drawer.restaurant.menu'.tr()),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushNamed(context, '/menu_list');
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title: Text('drawer.restaurant.weekendApply'.tr()),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushNamed(context, '/weekend_meal');
            },
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
           Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              'drawer.salon.title'.tr(),
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_task),
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title:  Text('drawer.salon.salonBooking'.tr()),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushNamed(context, '/salon_booking_step_one');
            },
          ),
          ListTile(
            leading: const Icon(Icons.content_paste_search),
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title:  Text('drawer.salon.priceList'.tr()),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushNamed(context, '/salon_price_list');
            },
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
           Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              'drawer.administration.title'.tr(),
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.campaign_outlined),
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title:  Text('drawer.administration.notice'.tr()),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushNamed(context, '/notice');
            },
          ),
          ListTile(
            leading: const Icon(Icons.construction),
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title: Text('drawer.administration.as'.tr()),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushNamed(context, '/as_application');
            },
          ),
          ListTile(
            leading: const Icon(Icons.work_history_outlined),
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title:  Text('drawer.administration.sleepover'.tr()),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushNamed(context, '/sleepover_application');
            },
          ),
          ListTile(
            leading: const Icon(Icons.groups_outlined),
            iconColor: Palette.mainColor,
            focusColor: Palette.mainColor,
            title: Text('drawer.administration.meetingRoom'.tr()),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushNamed(context, '/meeting_room_app');
            },
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
            title: Text(
              'drawer.logout'.tr(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => logoutService.logout(
                context, ref), // onTap 이벤트를 직접 logout 함수 호출로 변경
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
