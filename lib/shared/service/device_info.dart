import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceData;
  final storage = FlutterSecureStorage();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceData = 'Android ${androidInfo.version.sdkInt}, ${androidInfo.model}';
    storage.write(key: 'deviceType', value: 'Android');
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceData = 'iOS ${iosInfo.systemVersion}, ${iosInfo.utsname.machine}';
    storage.write(key: 'deviceType', value: 'iOS');
  } else {
    deviceData = 'Unknown device';
  }

  debugPrint('Device Info: ${await storage.read(key: 'deviceType')}');
}
