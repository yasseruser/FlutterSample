import 'dart:async';

import 'package:battery/battery.dart';
import 'package:flutter_learn/utils/toast.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  Utils._internal();

  static Battery _battery = Battery();
  static StreamSubscription _subscription;

  //=============url_launcher==================//

  ///处理链接
  static void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      XToast.error("暂不能处理这条链接:$url");
    }
  }

  //=============battery==================//

  ///获取电池电量
  static Future<int> getBattery() {
    return _battery.batteryLevel;
  }

  ///注册电量变化
  static void registerBatteryChanged(void onData(BatteryState event)) {
    if (_subscription != null) {
      _subscription.cancel();
    }
    _subscription = _battery.onBatteryStateChanged.listen(onData);
  }

  ///注销电量变化
  static void unregisterBatteryChanged() {
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  //=============package_info==================//

  ///获取应用包信息
  static Future<PackageInfo> getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  ///获取应用包信息
  static Future<Map<String, dynamic>> getPackageInfoMap() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return <String, dynamic>{
      'appName': packageInfo.appName,
      'packageName': packageInfo.packageName,
      'version': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
    };
  }

  static String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

}
