import 'dart:io';

import 'package:device_info/device_info.dart';

class DeviceUtil {
  static getDeviceName() async {
    if (Platform.isIOS) {
      return getIosDeviceName();
    } else if (Platform.isAndroid) {
      return getAndroidDeviceName();
    } else {
      return '未知设备';
    }
  }

  static getAndroidDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.device;
  }

  static getIosDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.utsname.machine;
  }
}
