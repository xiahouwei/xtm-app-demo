import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class XtmDeviceInfo {
  XtmDeviceInfo._internal();

  static final XtmDeviceInfo _singleton = XtmDeviceInfo._internal();

  factory XtmDeviceInfo() => _singleton;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  int hardwareInformationMaxLength = 50;

  Future<String> getDeviceId() async {
    String deviceId = '';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }
    return deviceId ?? '';
  }

  Future<String> getDeviceInfomatino() async {
    String hardwareInformation = '';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      hardwareInformation = '${androidInfo.manufacturer}__${androidInfo.model}';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      hardwareInformation =
          '${iosInfo.model}__${iosInfo.utsname.machine}__${iosInfo.systemName}__${iosInfo.systemVersion}';
    }
    if (hardwareInformation.length > hardwareInformationMaxLength) {
      return hardwareInformation.substring(0, hardwareInformationMaxLength);
    }
    return hardwareInformation;
  }

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<PackageInfo> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }
}

var xtmDeviceInfo = XtmDeviceInfo();
