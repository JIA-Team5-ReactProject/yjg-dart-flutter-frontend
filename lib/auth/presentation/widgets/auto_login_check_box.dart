import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/theme/palette.dart';

class AutoLoginCheckBox extends StatefulWidget {
  const AutoLoginCheckBox({super.key});

  @override
  State<AutoLoginCheckBox> createState() => _AutoLoginCheckBoxState();
}

class _AutoLoginCheckBoxState extends State<AutoLoginCheckBox> {
  final storage = FlutterSecureStorage();
  bool isAutoLogin = false;

  @override
  void initState() {
    super.initState();
    _loadAutoLoginStatus();
  }

  // 자동 로그인 상태 읽기
  Future<void> _loadAutoLoginStatus() async {
    final autoLoginStr = await storage.read(key: 'auto_login');
    setState(() { // 상태 업데이트
      isAutoLogin = autoLoginStr == 'true';
    });
  }

  // 자동 로그인 상태 업데이트
  Future<void> _updateAutoLoginStatus(bool value) async {
    await storage.write(key: 'auto_login', value: value.toString());
    setState(() {
      isAutoLogin = value; // isAutoLogin에 value 할당
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Checkbox(
        value: isAutoLogin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        activeColor: Palette.mainColor,
        onChanged: (value) async {
          if (value != null) {
            await _updateAutoLoginStatus(value);
          }
        },
      ),
      Text('login.sharedForm.automaticLogin'.tr(), style: TextStyle(fontSize: 14.0)),
    ]);
  }
}
