import 'package:easy_localization/easy_localization.dart';
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
    String? pushValue = await storage.read(key: 'push');
    bool push = pushValue == '1';
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
        title: 'settings.title'.tr(),
      ),
      drawer: BaseDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(
              'settings.common.title'.tr(),
              style: TextStyle(letterSpacing: -0.5),
            ),
            tiles: <SettingsTile>[

              // * 언어 설정
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text(
                  'settings.common.language.title'.tr(),
                  style: TextStyle(letterSpacing: -0.5, fontSize: 15.0),
                ),
                onPressed: ((context) async {
                  await showDialog<Locale>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('settings.common.language.title'.tr(),
                          style: TextStyle(
                              letterSpacing: -0.5,
                              fontSize: 15.0,
                              color: Palette.textColor,
                              fontWeight: FontWeight.w600)),
                      content: DropdownButton<Locale>(
                        value: context.locale,
                        items: [
                          DropdownMenuItem(
                            value: Locale('ja'),
                            child: Text('日本語',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    letterSpacing: -0.5,
                                    color: Palette.textColor)),
                          ),
                          DropdownMenuItem(
                            value: Locale('ko'),
                            child: Text('한국어',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    letterSpacing: -0.5,
                                    color: Palette.textColor)),
                          ),
                        ],
                        onChanged: (Locale? newLocale) {
                          if (newLocale != null) {
                            context.setLocale(newLocale);
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  );
                }),
              ),

              // * 푸쉬 알림 설정
              SettingsTile.switchTile(
                activeSwitchColor: Palette.mainColor,
                title: Text(
                  'settings.common.notification'.tr(),
                  style: TextStyle(letterSpacing: -0.5, fontSize: 15.0),
                ),
                initialValue: widget.notifications,
                onToggle: (value) async {
                  setState(() {
                    widget.notifications = value;
                  });

                  // 푸쉬 알림 허용 여부 업데이트
                  await pushNotificationUseCase.call(widget.notifications);

                  // SecureStorage에 알림 설정 저장
                  await storage.write(key: 'push', value: value ? '1' : '0');
                },
                leading: Icon(Icons.notifications),
              ),
            ],
          ),
          SettingsSection(
            title: Text(
              'settings.account.title'.tr(),
              style: TextStyle(letterSpacing: -0.5),
            ),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.logout),
                title: Text(
                  'settings.account.logout'.tr(),
                  style: TextStyle(letterSpacing: -0.5, fontSize: 15.0),
                ),
                onPressed: ((context) {
                  LogoutService().logout(context, ref);
                }),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.manage_accounts),
                title: Text(
                  'settings.account.informationUpdate'.tr(),
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
                  'settings.account.withdrawal.title'.tr(),
                  style: TextStyle(
                    letterSpacing: -0.5,
                    fontSize: 15.0,
                  ),
                ),
                onPressed: ((context) async {
                  final confirmDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                          'settings.account.withdrawal.confirm.title'.tr(),
                          style: TextStyle(
                              color: Palette.textColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600)),
                      content: Text(
                              'settings.account.withdrawal.confirm.description')
                          .tr(),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                              'settings.account.withdrawal.confirm.no'.tr(),
                              style: TextStyle(
                                  color: Palette.stateColor4,
                                  fontWeight: FontWeight.w600)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(
                              'settings.account.withdrawal.confirm.yes'.tr(),
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
                            content: Text(
                                    'settings.account.withdrawal.withdrawalSuccess')
                                .tr(),
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
                            content: Text(
                                    'settings.account.withdrawal.withdrawalFailed')
                                .tr(),
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
        ],
      ),
    );
  }
}
