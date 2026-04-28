import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

///通知管理工具
class NotificationManager {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  init() async {
    var android = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = const IOSInitializationSettings();
    var channelNormal = AndroidNotificationChannel(
      'normalNotification',
      '一般通知',
      description: '一般通知通道',
      importance: Importance.defaultImportance,
    );

    const AndroidNotificationChannel channelUrgent = AndroidNotificationChannel(
      'messageNotification',
      '消息通知',
      description: '消息通知通道',
      importance: Importance.max,
    );
    // 注册通道
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channelNormal);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channelUrgent);

    await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(android: android, iOS: ios),
        onSelectNotification: selectNotification);
  }

  //点击通知回调事件
  void selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  void send(int type, String title, String body, {int notificationId, String params}) {
    var androidDetails = createDetails(type);
    var iosDetails = const IOSNotificationDetails();
    var details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    flutterLocalNotificationsPlugin.show(
        notificationId ?? DateTime.now().millisecondsSinceEpoch >> 10, title, body, details,
        payload: params);
  }

  AndroidNotificationDetails createDetails(int type) {
    if (type == 1) {
      return AndroidNotificationDetails(
        'normalNotification',
        '一般通知',
      );
    } else if (type == 2) {
      return AndroidNotificationDetails(
        'messageNotification',
        '消息通知',
      );
    } else {
      return AndroidNotificationDetails(
        'messageNotification',
        '消息通知',
      );
    }
  }

  void cleanNotification() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  void cancelNotification(int id, {String tag}) {
    flutterLocalNotificationsPlugin.cancel(id, tag: tag);
  }
}

var notificationManager = NotificationManager();
