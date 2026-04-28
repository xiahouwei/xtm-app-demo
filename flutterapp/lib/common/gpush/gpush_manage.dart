import 'dart:convert';
import 'dart:io';
import 'package:flutter_proj/common/gpush/notification_redirect.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/utils/debounce_utils.dart';
import 'package:flutter_proj/common/gpush/notification_manage.dart';
import 'package:getuiflut/getuiflut.dart';

class GpushPluginManager {
  static GpushPluginManager _instance;

  static GpushPluginManager get instance {
    if (_instance == null) {
      _instance = GpushPluginManager._();
    }
    return _instance;
  }

  GpushPluginManager._();

  final debouncer = Debouncer();

  void init({Function(Map<String, dynamic> result) onTransmitUserMessageReceive}) async {
    await notificationManager.init();
    Getuiflut().addEventHandler(
      onReceiveOnlineState: (bool res) async {},
      onReceiveClientId: (String message) async {
        xtmGlobalStore.auth.setClientId(message);
      },
      onRegisterDeviceToken: (String message) async {
        Getuiflut().registerDeviceToken(message);
      },
      onReceivePayload: (Map<String, dynamic> message) async {},
      onReceiveNotificationResponse: (Map<String, dynamic> msg) async {
        Map<String, dynamic> params = jsonDecode(msg['payload']);
        NotificationRedirect.pushPage(params);
        resetBadgeForIOS();
      },
      onAppLinkPayload: (String message) async {},
      onPushModeResult: (Map<String, dynamic> message) async {},
      onSetTagResult: (Map<String, dynamic> message) async {},
      onAliasResult: (Map<String, dynamic> message) async {},
      onQueryTagResult: (Map<String, dynamic> message) async {},
      onWillPresentNotification: (Map<String, dynamic> message) async {},
      onOpenSettingsForNotification: (Map<String, dynamic> message) async {},
      onGrantAuthorization: (String granted) async {},
      onNotificationMessageClicked: (Map<String, dynamic> msg) async {},
      onNotificationMessageArrived: (Map<String, dynamic> msg) async {},
      onLiveActivityResult: (Map<String, dynamic> msg) async {},
      onReceiveMessageData: (Map<String, dynamic> msg) async {},
      onTransmitUserMessageReceive: (Map<String, dynamic> msg) async {
        Map<String, dynamic> params = jsonDecode(msg['msg']);
        debouncer.run(() {
          NotificationRedirect.pushPage(params);
        });
        Getuiflut().setBadge(0);
      },
    );
    if (Platform.isIOS) {
      Getuiflut().startSdk(
        appId: "",
        appKey: "",
        appSecret: "",
      );
      resetBadgeForIOS();
      getLaunchNotification();
    } else {
      Getuiflut.initGetuiSdk;
      Getuiflut().setBadge(0);
    }
  }

  Future<void> getLaunchNotification() async {
    Map info;
    try {
      info = await Getuiflut.getLaunchNotification;
      Map<String, dynamic> params = jsonDecode(info['payload']);
      Future.delayed(Duration(milliseconds: 1000)).then((value) {
        NotificationRedirect.pushPage(params);
      });
      resetBadgeForIOS();
    } catch (e) {
      print(e.toString());
    }
  }

  void resetBadgeForIOS() {
    Getuiflut().resetBadge();
    Getuiflut().setLocalBadge(-1);
  }
}
