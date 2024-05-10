import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/material.dart';
import 'package:yjg/auth/data/data_resources/user_data_source.dart';
import 'package:yjg/setting/data/data_sources/fcm_token_datasource.dart';
import 'package:yjg/setting/domain/usecases/push_notification_usecase.dart';
import 'package:yjg/shared/service/logout_service.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';

class SettingPage extends ConsumerStatefulWidget {
  SettingPage({Key? key}) : super(key: key);
  bool notifications = false;
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends ConsumerState<SettingPage> {
  static final storage = FlutterSecureStorage();
  static String? userType;
  final pushNotificationUseCase = PushNotificationUseCase(FcmTokenDataSource());

  // storage에서 isAdmin 값을 읽어와서 상태를 업데이트하는 메소드
  Future<void> getUserInfo() async {
    userType = await storage.read(key: 'userType');
  }

  Future<void> getPushNotification() async {
    final storage = FlutterSecureStorage();
    bool push = await storage.read(key: 'push') == '0' ? false : true;
    setState(() {
      widget.notifications = push;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getPushNotification();
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

              SettingsTile.switchTile(
                activeSwitchColor: Palette.mainColor,
                title: Text(
                  '알림',
                  style: TextStyle(letterSpacing: -0.5, fontSize: 15.0),
                ),
                initialValue: widget.notifications,
                onToggle: (value) {
                  setState(() {
                    widget.notifications = !widget.notifications;

                    // 푸쉬 알림 허용 여부 업데이트
                    pushNotificationUseCase.call(widget.notifications);
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
                  LogoutService().logout(context, ref);
                }),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.manage_accounts),
                title: Text(
                  '개인정보 수정',
                  style: TextStyle(letterSpacing: -0.5, fontSize: 15.0),
                ),
                onPressed: ((context) {
                  userType == 'student'
                      ? Navigator.of(context).pushNamed('/update_user')
                      : Navigator.of(context).pushNamed('/update_admin');
                }),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.person_remove),
                title: Text(
                  '회원탈퇴',
                  style: TextStyle(
                    letterSpacing: -0.5,
                    fontSize: 15.0,
                  ),
                ),
                onPressed: ((context) async {
                  final confirmDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('회원탈퇴',
                          style: TextStyle(
                              color: Palette.textColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600)),
                      content: Text('정말 회원탈퇴 하시겠습니까? 탈퇴 후 복구가 불가능합니다.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('취소',
                              style: TextStyle(
                                  color: Palette.stateColor4,
                                  fontWeight: FontWeight.w600)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('삭제',
                              style: TextStyle(
                                  color: Palette.stateColor3,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  );

                  if (confirmDelete == true) {
                    try {
                      UserDataSource().deleteUserAccountAPI();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('회원탈퇴에 성공하였습니다. 로그아웃됩니다.'),
                            backgroundColor: Palette.mainColor,
                          ),
                        );

                        Navigator.pushNamedAndRemoveUntil(context,
                            '/login_student', (Route<dynamic> route) => false);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('회원탈퇴 실패. 다시 시도해 주세요. 에러: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
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
