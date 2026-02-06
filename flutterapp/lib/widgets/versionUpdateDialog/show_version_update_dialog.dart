import 'dart:io';

import 'package:flutter_proj/config/api_interface_config/index.dart';
import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/utils/navigator_provider_utils.dart';
import 'package:flutter_proj/widgets/versionUpdateDialog/updata_manage.dart';
import 'package:flutter_proj/widgets/versionUpdateDialog/version_update_dialog.dart';
import 'package:flutter_proj/xtmdesign_component/src/components/toast/xtm_toast.dart';
import 'package:url_launcher/url_launcher_string.dart';

bool _alreadyShowDialog = false;

void showVersionUpdateDialog() {
  if (_alreadyShowDialog) return;
  _alreadyShowDialog = true;
  Map param = {};
  param['deviceType'] = Platform.isIOS ? 'ios' : 'android';
  param['branchType'] = '4';
  xtmApi.auth.versionUpdate(params: param).then((res) {
    String downloadUrl = res['url'];
    String boxUrl = res['boxUrl'];
    String latestVersion = res['version'];
    _showVersionUpdateDialog(
        latestVersion: latestVersion, downloadUrl: downloadUrl, boxUrl: boxUrl);
  }).catchError((err) {
    _alreadyShowDialog = false;
  });
}

void openBrowser(String url) async {
  if (url == null || url.isEmpty) {
    XtmToast.warn('无法获取下载链接，请重试');
    return;
  }
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  } else {
    XtmToast.warn('无法打开浏览器,请检查是否安装浏览器');
  }
}

void _showVersionUpdateDialog({String latestVersion, String downloadUrl, String boxUrl}) {
  String curVersion = HTTPConfig.apiVersion;
  String curVersionDesc = '当前软件版本为V$curVersion，请更新软件后使用';
  String latestVersionDesc = '';
  if (latestVersion != null && latestVersion.isNotEmpty) {
    latestVersionDesc = '最新软件版本为V$latestVersion';
  }

  if (Platform.isIOS) {
    xtmShowVersionUpdateDialog(NavigatorProvider.navigatorContext,
        latestVersionDesc: latestVersionDesc,
        currentVersionDesc: curVersionDesc,
        hiddenBoxButton: true, onLeftTap: () {
      UpDataManage.downLoad(NavigatorProvider.navigatorContext, downloadUrl, boxUrl,
          callback: (bool isSuccess) {
        _alreadyShowDialog = false;
      });
    });
    return;
  }

  xtmShowVersionUpdateDialog(NavigatorProvider.navigatorContext,
      latestVersionDesc: latestVersionDesc,
      currentVersionDesc: curVersionDesc,
      hiddenBoxButton: (boxUrl == null || boxUrl.isEmpty), onLeftTap: () {
    if (downloadUrl == null || downloadUrl.isEmpty) {
      XtmToast.warn('未获取到下载链接，请联系管理员');
      _alreadyShowDialog = false;
    } else {
      UpDataManage.downLoad(NavigatorProvider.navigatorContext, downloadUrl, boxUrl,
          callback: (bool isSuccess) {
        _alreadyShowDialog = false;
      });
    }
  }, onRightTap: () {
    openBrowser(boxUrl);
    _alreadyShowDialog = false;
  });
}
