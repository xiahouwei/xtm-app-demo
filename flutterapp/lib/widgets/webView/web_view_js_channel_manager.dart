import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_proj/config/api_interface_config/index.dart';
import 'package:flutter_proj/device/index.dart';
import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/utils/navigator_provider_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewJsChannelManager {
  WebViewJsChannelManager();

  WebViewController _controller;

  /// 给调用页回调数据
  Function(Map<String, dynamic> data) onCallBack;
  BuildContext context;

  void setControl(WebViewController controller) {
    _controller = controller;
  }

  void setCallBack(BuildContext context, Function(Map<String, dynamic> data) callBack) {
    this.context = context;
    this.onCallBack = callBack;
  }

  JavascriptChannel createChannel(String name, Function(JavascriptMessage) onMessage) {
    return JavascriptChannel(
      name: name,
      onMessageReceived: (message) => onMessage(message),
    );
  }

  Set<JavascriptChannel> buildJavascriptChannels() {
    return [
      /// 页面返回
      createChannel('backToPrimary', backToPrimaryHandler),

      /// 获取基础数据
      createChannel('getBaseInfo', getBaseInfoHandler),

      /// 获取定位
      createChannel('requestLocationFromFlutter', requestLocationFromFlutterHandler),

      /// 获取录音权限
      createChannel('flutterRecordPermission', flutterRecordPermissionHandler),

      /// 开始录音
      createChannel('flutterRecordStart', flutterRecordStartHandler),

      /// 停止录音
      createChannel('flutterRecordStop', flutterRecordStopHandler),

      /// 取消录音
      createChannel('flutterRecordCancel', flutterRecordCancelHandler),

      /// 拍照
      createChannel('flutterImagePickerByCamera', flutterImagePickerByCameraHandler),

      /// 从相册获取图片
      createChannel('flutterImagePickerByGallery', flutterImagePickerByGalleryHandler),

      /// 从相册获取视频
      createChannel('flutterVideoPickerByGallery', flutterVideoPickerByGalleryHandler),

      /// 选取文件
      createChannel('flutterFilePicker', flutterFilePickerHandler),

      /// 记录im最后联系时间
      createChannel(
          'flutterSaveChatMessageLastDatetime', flutterSaveChatMessageLastDatetimeHandler),

      /// 打开默认浏览器
      createChannel('flutterOpenBrowser', flutterOpenBrowserHandler),

      createChannel('verifyCaptchaSuccess', flutterPopWithInfo),

      createChannel('captchaClose', (JavascriptMessage message) => Navigator.of(context).pop()),
    ].toSet();
  }

  void backToPrimaryHandler(JavascriptMessage message) {
    Navigator.pop(NavigatorProvider.navigatorContext);
  }

  void getBaseInfoHandler(JavascriptMessage message) {
    String baseInfoStr = assembleBaseInfo();
    _controller.evaluateJavascript("CommonApp.setCommonParam('$baseInfoStr')");
  }

  String assembleBaseInfo() {
    String deviceType = '';
    if (Platform.isIOS) {
      deviceType = 'ios';
    } else {
      deviceType = 'android';
    }
    Map<String, String> dict = {
      "userID": xtmGlobalStore.auth.userInfo.userID,
      "userName": xtmGlobalStore.auth.userInfo.userName,
      "mobile": xtmGlobalStore.auth.userInfo.mobile,
      "token": xtmGlobalStore.auth.token,
      "companyID": xtmGlobalStore.auth.userInfo.companyInfo.companyID,
      "appKey": HTTPConfig.appKey,
      "appSecret": HTTPConfig.appSecret,
      "agentCode": xtmGlobalStore.auth.userInfo.companyInfo.companyAgentCode,
      "version": HTTPConfig.apiVersion,
      "deviceType": deviceType,
    };
    String baseInfoStr = jsonEncode(dict);
    return baseInfoStr;
  }

  void requestLocationFromFlutterHandler(JavascriptMessage message) {
    xtmDevice.location.startLocationOnce().then((res) {
      String infoStr = jsonEncode(res);
      _controller.evaluateJavascript("postCurrentLocationToJS('$infoStr')");
    });
  }

  void flutterRecordPermissionHandler(JavascriptMessage message) {
    xtmDevice.permission.requestRecordPermission().then((value) {
      _controller.evaluateJavascript("webviewChatCallback.recoderPermissionCallback('')");
    });
  }

  void flutterRecordStartHandler(JavascriptMessage message) {
    xtmDevice.permission.requestRecordPermission().then((value) {
      xtmDevice.record.start();
    });
  }

  void flutterRecordStopHandler(JavascriptMessage message) {
    xtmDevice.record.stop().then((value) async {
      xtmApi.im.uploadFile(value).then((value) {
        String infoStr = jsonEncode(value);
        _controller.evaluateJavascript("webviewChatCallback.recoderCallback('$infoStr')");
      }).catchError((err) {
        _controller.evaluateJavascript("webviewChatCallback.recoderCallback('')");
      });
    });
  }

  void flutterRecordCancelHandler(JavascriptMessage message) {
    xtmDevice.record.cancel();
  }

  Future<void> flutterImagePickerByCameraHandler(JavascriptMessage message) async {
    await xtmDevice.permission.requestCameraPermission();
    xtmDevice.imagePicker.getImageByCamera().then((path) async {
      xtmApi.im.uploadFile(path).then((value) {
        String infoStr = jsonEncode(value);
        _controller.evaluateJavascript("webviewChatCallback.cameraCallback('$infoStr')");
      }).catchError((err) {
        _controller.evaluateJavascript("webviewChatCallback.cameraCallback('')");
      });
    });
  }

  Future<void> flutterImagePickerByGalleryHandler(JavascriptMessage message) async {
    await xtmDevice.permission.requestPhotoAlbumPermission();
    xtmDevice.imagePicker.getImageByGallery().then((path) async {
      xtmDevice.imagePicker.getImageByCamera().then((path) async {
        xtmApi.im.uploadFile(path).then((value) {
          String infoStr = jsonEncode(value);
          _controller.evaluateJavascript("webviewChatCallback.galleryCallback('$infoStr')");
        }).catchError((err) {
          _controller.evaluateJavascript("webviewChatCallback.galleryCallback('')");
        });
      });
    });
  }

  void flutterVideoPickerByGalleryHandler(JavascriptMessage message) {
    xtmDevice.imagePicker.getVideoByGallery().then((path) async {
      xtmApi.im.uploadFile(path).then((value) {
        String infoStr = jsonEncode(value);
        _controller.evaluateJavascript("webviewChatCallback.videoCameraCallback('$infoStr')");
      }).catchError((err) {
        _controller.evaluateJavascript("webviewChatCallback.videoCameraCallback('')");
      });
    });
  }

  void flutterFilePickerHandler(JavascriptMessage message) {
    xtmDevice.filePicker.pickFile().then((path) async {
      xtmDevice.imagePicker.getVideoByGallery().then((path) async {
        xtmApi.im.uploadFile(path).then((value) {
          String infoStr = jsonEncode(value);
          _controller.evaluateJavascript("webviewChatCallback.filePickerCallback('$infoStr')");
        }).catchError((err) {
          _controller.evaluateJavascript("webviewChatCallback.filePickerCallback('')");
        });
      });
    });
  }

  void flutterSaveChatMessageLastDatetimeHandler(JavascriptMessage message) {
    xtmGlobalStore.system.setLastChatMessageDatetime(message.message);
  }

  void flutterOpenBrowserHandler(JavascriptMessage message) {
    launchUrl(Uri.parse(message.message), mode: LaunchMode.externalApplication);
  }

  void flutterPopWithInfo(JavascriptMessage message) {
    onCallBack({'code': message.message});
    Navigator.of(context).pop();
  }
}
