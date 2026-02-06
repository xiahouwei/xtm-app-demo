import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/utils/async_utils.dart';
import 'package:flutter_proj/utils/navigator_provider_utils.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

class XtmPermissionHandler {
  XtmPermissionHandler._internal();

  static final XtmPermissionHandler _singleton = XtmPermissionHandler._internal();

  factory XtmPermissionHandler() => _singleton;

  /// 定位权限
  Future<bool> requestLocationPermission() {
    return AsyncUtils.PromiseFunction<bool>((promise) async {
      PermissionStatus status = await Permission.location.status;
      if (status != PermissionStatus.granted) {
        Timer delay = Timer(Duration(milliseconds: 300), () {
          showPermissionDesc(
            '位置权限使用说明',
            '用于搜索距离您最近的能源站点，或者确认您是否已经进入订单装卸位置',
          );
        });
        status = await Permission.location.request();
        BotToast.cleanAll();
        delay.cancel();
        if (status != PermissionStatus.granted) {
          promise.complete(false);
          return;
        }
      }
      promise.complete(true);
    });
  }

  /// 后台定位权限
  Future<bool> requestBackLocationPermission() {
    return AsyncUtils.PromiseFunction<bool>((promise) async {
      PermissionStatus status = await Permission.locationAlways.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.locationAlways.request();
        if (status != PermissionStatus.granted) {
          promise.complete(false);
          return;
        }
      }
      promise.complete(true);
    });
  }

  /// 相机权限
  Future<bool> requestCameraPermission() {
    return AsyncUtils.PromiseFunction<bool>((promise) async {
      PermissionStatus status = await Permission.camera.status;
      if (status != PermissionStatus.granted) {
        Timer delay = Timer(Duration(milliseconds: 300), () {
          showPermissionDesc(
            '摄像头权限使用说明',
            '用于充换电的扫码验证，或者拍摄所需单据进行上传，或者拍摄车辆信息等',
          );
        });
        status = await Permission.camera.request();
        BotToast.cleanAll();
        delay.cancel();
        if (status != PermissionStatus.granted) {
          showPermissionDialog('未获取到摄像头权限，为保证正常使用，请去设置中开启相机权限');
          return;
        }
      }
      promise.complete();
    });
  }

  /// 相册权限
  Future<bool> requestPhotoAlbumPermission() {
    return AsyncUtils.PromiseFunction<bool>((promise) async {
      if (Platform.isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        if (androidInfo.version.sdkInt < 33) {
          bool isGranted = await Permission.storage.isGranted;
          if (!isGranted) {
            Timer delay = Timer(Duration(milliseconds: 300), () {
              showPermissionDesc(
                '文档权限使用说明',
                '用于选择照片进行上传，完成订单的流转，或者上传证照信息完成认证等',
              );
            });
            PermissionStatus status = await Permission.storage.request();
            BotToast.cleanAll();
            delay.cancel();

            if (!status.isGranted) {
              showPermissionDialog('未开启相册文件访问权限，为保证正常使用，请去设置中开启文件权限');
              return;
            }
          }
        } else {
          bool isGranted = await Permission.photos.isGranted;
          if (!isGranted) {
            Timer delay = Timer(Duration(milliseconds: 300), () {
              showPermissionDesc(
                '文档权限使用说明',
                '用于选择照片上传，完成订单的流转，或者上传证照信息完成认证等',
              );
            });
            PermissionStatus status = await Permission.photos.request();
            BotToast.cleanAll();
            delay.cancel();
            if (!status.isGranted) {
              showPermissionDialog('未开启相册文件访问权限，为保证正常使用，请去设置中开启文件权限');
              return;
            }
          }
        }
      } else {
        bool isGranted = await Permission.photos.isGranted;
        if (!isGranted) {
          PermissionStatus status = await Permission.photos.request();
          if (status.isPermanentlyDenied) {
            showPermissionDialog('未开启相册文件访问权限，为保证正常使用，请去设置中开启文件权限');
            return;
          }
        }
      }
      promise.complete();
    });
  }

  /// 通知权限
  Future<void> requestNotificationPermission() {
    return AsyncUtils.PromiseFunction<bool>((promise) async {
      PermissionStatus status = await Permission.notification.status;
      if (status != PermissionStatus.granted) {
        Timer delay = Timer(Duration(milliseconds: 300), () {
          showPermissionDesc(
            '通知权限使用说明',
            '用于接收订单信息、账号认证信息、账户信息、站内信信息以及各种提醒信息',
          );
        });
        status = await Permission.notification.request();
        BotToast.cleanAll();
        delay.cancel();
        if (status != PermissionStatus.granted) {
          showPermissionDialog('未开启通知权限，无法接受推送消息，为保证正常使用,请去设置中开启权限');
          return;
        }
      }
      promise.complete();
    });
  }

  /// 录音权限
  Future<bool> requestRecordPermission() async {
    return AsyncUtils.PromiseFunction<bool>((promise) async {
      PermissionStatus status = await Permission.microphone.status;
      if (status != PermissionStatus.granted) {
        Timer delay = Timer(Duration(milliseconds: 300), () {
          showPermissionDesc(
            '录音权限使用说明',
            '用于客服聊天中语音信息的发送',
          );
        });
        status = await Permission.microphone.request();
        BotToast.cleanAll();
        delay.cancel();
        if (status != PermissionStatus.granted) {
          showPermissionDialog('未获取到麦克风权限，为保证正常使用,请去设置中开启');
          return;
        }
      }
      promise.complete();
    });
  }

  /// 通讯录权限
  Future<bool> requestContactPermission() async {
    return AsyncUtils.PromiseFunction<bool>((promise) async {
      PermissionStatus status = await Permission.contacts.status;
      if (status != PermissionStatus.granted) {
        Timer delay = Timer(Duration(milliseconds: 300), () {
          showPermissionDesc(
            '通讯录权限使用说明',
            '用于订单的创建，选择收发货人的具体联系方式等',
          );
        });
        status = await Permission.contacts.request();
        BotToast.cleanAll();
        delay.cancel();
        if (status != PermissionStatus.granted) {
          showPermissionDialog('未获取到通讯录权限，为保证正常使用,请去设置中开启');
          return;
        }
      }
      promise.complete();
    });
  }

  void showPermissionDialog(String permissionContent) {
    final globalContext = NavigatorProvider.navigatorContext;
    XtmConfirmDialog.show(
      globalContext,
      message: permissionContent,
      rightBtnTitle: "去设置",
    ).then((value) => openAppSettings());
  }

  /// 权限说明
  void showPermissionDesc(String title, String desc, {CancelFunc cancel}) {
    if (Platform.isIOS) {
      return;
    }
    BotToast.showCustomText(
      onlyOne: true,
      crossPage: false,
      duration: Duration(seconds: 30),
      toastBuilder: (cancelFun) {
        cancel = cancelFun;
        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(desc, style: TextStyle(color: Colors.black87)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

var xtmPermission = XtmPermissionHandler();
