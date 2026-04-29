import 'dart:io';

import 'package:dio/dio.dart';
import 'package:install_plugin_v2/install_plugin_v2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/widgets/progress_indicator.dart';
import 'package:flutter_proj/common/event_bus/event_bus.dart';
import 'package:flutter_proj/common/event_bus/event_bus_type.dart';
import 'package:flutter_proj/config/app_config.dart';

typedef DownloadCallback = Function(bool isSuccess);

class UpDataManage {
  static _downloadCallback(DownloadCallback callback, bool isSuccess) {
    if (callback != null) {
      callback(isSuccess);
    }
  }

  //下载并打开文件
  static downLoad(BuildContext context, String downloadUrl, String boxUrl,
      {DownloadCallback callback}) async {
    // 获取APP安装路径
    if (Platform.isIOS) {
      String url = AppConfig.APP_STORE_URL;
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        throw 'Could not launch: $url';
      }
      _downloadCallback(callback, true);
    } else if (Platform.isAndroid) {
      ProgressIndicatorManage.showProgressIndicator(context);
      String url = downloadUrl;
      installApk(context, url, callback);
    }
  }

  /// 安装apk
  static Future<Null> installApk(
      BuildContext context, String url, DownloadCallback callback) async {
    ///下载安装包
    File _apkFile = await downloadAndroid(url);
    if (_apkFile != null && _apkFile.path != null) {
      String _apkFilePath = _apkFile.path;
      if (_apkFilePath.isEmpty) {
        print('make sure the apk file is set');
        _downloadCallback(callback, false);
        return;
      }

      InstallPlugin.installApk(_apkFilePath, AppConfig.APP_ANDROID_ID).then((result) {
        _downloadCallback(callback, true);
        Navigator.pop(context);
        print('install apk $result');
      }).catchError((error) {
        _downloadCallback(callback, false);
        print('install apk error: $error');
      });
    }
  }

  /// 下载安卓更新包
  static Future<File> downloadAndroid(String url) async {
    /// 创建存储文件
    Directory storageDir = await getExternalStorageDirectory();
    String storagePath = storageDir.path;
    File file = new File('$storagePath/android.apk');

    if (!file.existsSync()) {
      file.createSync();
    }

    try {
      /// 发起下载请求
      Response response = await Dio().get(url,
          onReceiveProgress: showDownloadProgress,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
          ));
      file.writeAsBytesSync(response.data);
      return file;
    } catch (e) {
      return file;
    }
  }

  static void showDownloadProgress(int received, int total) {
    if (total != -1) {
      int receiveCount = ((received / total) * 100).toInt();
      if (receiveCount > 0) {
        xtmGlobalStore.system.setReceiveCount(receiveCount);
        eventBus.fire(EventBusType.PROGRESS_UPDATE);
      }
    }
  }
}
