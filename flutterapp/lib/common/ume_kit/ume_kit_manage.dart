import 'package:flutter/material.dart';
import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/network/http_manager.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart';
import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart';
import 'package:flutter_ume_kit_perf/flutter_ume_kit_perf.dart';

class UmeKitPluginManager {
  static UmeKitPluginManager _instance;

  static UmeKitPluginManager get instance {
    if (_instance == null) {
      _instance = UmeKitPluginManager._();
    }
    return _instance;
  }

  UmeKitPluginManager._();

  Widget createApp(Widget app) {
    final kitEnableMap = getKitEnableMap();
    if (kitEnableMap['kitEnable']) {
      registerUmeKitPlugin(kitEnableMap);
      return UMEWidget(
        child: app,
        enable: true,
      );
    }
    return app;
  }

  Map<String, bool> getKitEnableMap() {
    final appEnvConfig = EnvConfig.current;
    return {
      'kitEnable': appEnvConfig.dioKit == UME_KIT.OPEN || appEnvConfig.umeKit == UME_KIT.OPEN,
      'dioKitEnable': appEnvConfig.dioKit == UME_KIT.OPEN,
      'umeKitEnable': appEnvConfig.umeKit == UME_KIT.OPEN
    };
  }

  void registerUmeKitPlugin(Map<String, bool> kitEnableMap) {
    if (kitEnableMap['dioKitEnable']) {
      PluginManager.instance..register(DioInspector(dio: xtmDioHttp));
    }
    if (kitEnableMap['umeKitEnable']) {
      PluginManager.instance
        ..register(Console())
        ..register(Performance())
        ..register(MemoryInfoPage());
    }
  }
}
