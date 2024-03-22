import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/material.dart';
import 'package:yjg/shared/service/auth_service.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';

bool notifications = false;

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: '설정',
      ),
      drawer: BaseDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(
              '공통',
              style: TextStyle(letterSpacing: -0.5),
            ),
            tiles: <SettingsTile>[
              // TODO: 추후 언어 설정 추가
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text(
                  '언어',
                  style: TextStyle(letterSpacing: -0.5, fontSize: 15.0),
                ),
                value: Text(
                  '한국어',
                  style: TextStyle(letterSpacing: -0.5, fontSize: 16.0),
                ),
                onPressed: ((context) {}),
              ),

              // TODO: 추후 알림 설정 추가
              SettingsTile.switchTile(
                title: Text(
                  '알림',
                  style: TextStyle(letterSpacing: -0.5, fontSize: 15.0),
                ),
                initialValue: notifications,
                onToggle: (value) {
                  setState(() {
                    notifications = !notifications;
                  });
                },
                leading: Icon(Icons.notifications),
              ),
            ],
          ),
          SettingsSection(
            title: Text(
              '계정',
              style: TextStyle(letterSpacing: -0.5),
            ),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.logout),
                title: Text(
                  '로그아웃',
                  style: TextStyle(letterSpacing: -0.5, fontSize: 15.0),
                ),
                onPressed: ((context) {
                  AuthService().logout(context, ref);
                }),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.person),
                title: Text(
                  '개인정보 수정',
                  style: TextStyle(letterSpacing: -0.5, fontSize: 15.0),
                ),
                onPressed: ((context) {
                  Navigator.of(context).pushNamed('/update_user');
                }),
              ),
            ],
          ),
          SettingsSection(
            title: Text(
              '기타',
              style: TextStyle(letterSpacing: -0.5),
            ),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.star),
                title: Text(
                  '앱 평가하기',
                  style: TextStyle(letterSpacing: -0.5, fontSize: 15.0),
                ),
                onPressed: ((context) {}),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
