import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/device/index.dart';
import 'package:flutter_proj/widgets/tms_loading.dart';
import 'package:flutter_proj/xtmdesign_component/src/components/toast/xtm_toast.dart';
import 'package:flutter_proj/config/app_config.dart';

class XtmLocation {
  AMapFlutterLocation _locationOncePlugin;
  int _locationMaxTime = 30;

  /// 默认持续定位间隔  秒
  int _locationInterval = 5;
  Timer _locationStartTimer;
  Timer _locationPersistentTimer;
  Completer<Map> _locationCompleter;

  /// 定位次数
  int _locationNum = 1;

  static final XtmLocation _instance = XtmLocation._internal();

  factory XtmLocation() => _instance;

  XtmLocation._internal() {
    AMapFlutterLocation.setApiKey(AppConfig.APP_AMAP_KEY_ANDROID, AppConfig.APP_AMAP_KEY_IOS);
    _locationOncePlugin = AMapFlutterLocation();
    _locationOncePlugin.onLocationChanged().listen((Map<String, Object> result) {
      print('=====高德回调=====$result');
      _handleLocationResult(result);
      _locationOncePlugin.stopLocation();
    });
  }

  _handleLocationResult(Map<String, dynamic> result) {
    String address = result['address'];
    if (address != null && address.isNotEmpty) {
      if (result != null) {
        print('=====定位结果=====${jsonEncode(result)}');
        _locationOncePlugin.stopLocation();
        _locationStartTimerCancel();
        Map<String, dynamic> locationResult = Map();
        locationResult['callbackTime'] = result['callbackTime'];
        if (Platform.isIOS) {
          locationResult['locationTime'] = result['locTime'];
        } else {
          locationResult['locationTime'] = result['locationTime'];
        }
        locationResult['latitude'] =
            result['latitude'] == null ? 0 : (result['latitude'] * 1e6).truncate() / 1e6;
        locationResult['longitude'] =
            result['longitude'] == null ? 0 : (result['longitude'] * 1e6).truncate() / 1e6;
        locationResult['address'] = result['address'] ?? "";
        locationResult['speed'] = result['speed'];
        if (_locationCompleter != null && !_locationCompleter.isCompleted) {
          _locationCompleter.complete(locationResult);
        }
      }
    } else {
      _locationNum++;
    }
    TmsLoading.dismiss();
    if (_locationNum > (Platform.isAndroid ? 5 : 10)) {
      _locationOncePlugin.stopLocation();
      _locationStartTimerCancel();
      XtmToast.warn('定位失败，请退出后重试');
      _locationCompleter.completeError('error');
      _locationNum = 1;
    }
  }

  /// 单次定位
  Future<Map> startLocationOnce({bool loading = false}) async {
    _locationNum = 1;
    _locationCompleter = Completer<Map>();
    await _startLocation(loading);
    return _locationCompleter.future;
  }

  /// 持续定位
  void startLocationPersistent({
    bool loading = false,
    int locationInterval,
    @required Function(Map<String, dynamic> result) onLocationChanged,
  }) async {
    await xtmDevice.permission.requestBackLocationPermission();
    // 马上执行一次
    startLocationOnce().then((value) => onLocationChanged(value));
    if (_locationPersistentTimer != null) {
      _locationPersistentTimer.cancel();
    }
    _locationPersistentTimer =
        Timer.periodic(Duration(seconds: locationInterval ?? _locationInterval), (timer) {
      startLocationOnce().then((value) => onLocationChanged(value));
    });
  }

  Future<void> _startLocation(bool loading) async {
    bool isGranted = await xtmDevice.permission.requestLocationPermission();
    if (isGranted) {
      if (loading) {
        TmsLoading.showLoading();
      }
      if (_locationStartTimer != null) {
        _locationStartTimer.cancel();
      }
      setLocationOption();
      _locationOncePlugin.startLocation();
      _locationStartTimer = Timer(Duration(seconds: _locationMaxTime), () {
        TmsLoading.dismiss();
        _locationOncePlugin.stopLocation();
        XtmToast.error('定位失败，请退出后重试');
      });
      _requestAccuracyAuthorization();
    } else {
      XtmToast.warn('未开启定位，请开启后重试');
    }
  }

  void setLocationOption() {
    AMapLocationOption locationOption = AMapLocationOption();

    /// 单次定位开关
    locationOption.onceLocation = false;

    ///设置Android端连续定位的定位间隔
    locationOption.locationInterval = 4000;

    ///是否需要返回逆地理信息
    locationOption.needAddress = true;

    ///逆地理信息的语言类型
    locationOption.geoLanguage = GeoLanguage.DEFAULT;
    locationOption.desiredLocationAccuracyAuthorizationMode =
        AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;
    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

    ///设置Android端的定位模式<br>
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

    ///设置iOS端的定位最小更新距离<br>
    locationOption.distanceFilter = -1;

    ///设置iOS端期望的定位精度
    locationOption.desiredAccuracy = DesiredAccuracy.Best;

    ///设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;
    if (_locationOncePlugin != null) {
      _locationOncePlugin.setLocationOption(locationOption);
    }
  }

  void _locationStartTimerCancel() {
    if (_locationStartTimer != null) {
      _locationStartTimer.cancel();
    }
  }

  /// 停止持续定位
  void stopLocationPersistent() {
    if (_locationPersistentTimer != null) {
      _locationPersistentTimer.cancel();
    }
  }

  ///获取iOS native的accuracyAuthorization类型
  void _requestAccuracyAuthorization() async {
    if (Platform.isAndroid) {
      return;
    }
    AMapAccuracyAuthorization currentAccuracyAuthorization =
        await _locationOncePlugin.getSystemAccuracyAuthorization();
    if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
      print("精确定位类型");
    } else if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
      print("模糊定位类型");
    } else {
      print("未知定位类型");
    }
  }
}

final XtmLocation xtmLocation = XtmLocation();
