import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/network/http_response_code.dart';
import 'package:flutter_proj/network/http_manager.dart';
import 'package:flutter_proj/widgets/show_invalidate_token_dialog.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import 'package:flutter_proj/utils/navigator_provider_utils.dart';

class TmsHttpRequest {
  static String TMS_SERVER_PATH = '/api/';
  static String getBaseUrl() {
    return '${HTTPConfig.serverDomain}${TmsHttpRequest.TMS_SERVER_PATH}';
  }

  static FormData handleFormData({String path, Map params}) {
    String platform = '';
    if (Platform.isIOS) {
      platform = 'ios';
    } else {
      platform = 'android';
    }
    Map jsonHeader = {
      'header': {
        'serviceName': path,
        'userAgent': platform,
        'privateField': null,
      },
    };
    bool ok1 = path.contains('platform/getIndexSetting');
    bool ok2 = path.contains('getLoginType');
    if (ok1 || ok2) {
      String appKey = HTTPConfig.appKey;
      jsonHeader['body'] = appKey;
    } else {
      jsonHeader['body'] = params;
    }
    String headerJsonStr = jsonEncode(jsonHeader);
    String appSecret = HTTPConfig.appSecret;
    String token = xtmGlobalStore.auth.token ?? '';
    String appKey = HTTPConfig.appKey;
    String apiVersion = HTTPConfig.apiVersion;

    String sign = appSecret +
        token +
        "app_key" +
        appKey +
        "timestamp" +
        "1554800952074" +
        "version" +
        apiVersion +
        "param" +
        headerJsonStr +
        appSecret;
    String strSignContents = Uri.encodeComponent(sign);
    String ss = md5.convert(utf8.encode(strSignContents)).toString().toUpperCase();
    String platMode = '0';
    FormData newFormData = FormData.fromMap({
      'secretKey': appSecret,
      'app_key': appKey,
      'version': apiVersion,
      'timestamp': '1554800952074',
      'access_token': token,
      'sign': ss,
      'platMode': platMode,
      'param': headerJsonStr
    });
    return newFormData;
  }

  static void handleResponse(
    Response response,
    Function(dynamic result) onSuccess,
    Function(Map<String, dynamic> result) onError, {
    bool showErrorDialog,
    Function(Map<String, dynamic> result) uncertificatedCallback,
    ResponseType responseType,
    ResponseReturnLevel responseReturnLevel,
  }) {
    if (responseType != null && responseType == ResponseType.bytes) {
      if (onSuccess != null) {
        onSuccess({'bytes': response.data});
      }
      return;
    }

    Map resultData;
    try {
      resultData = jsonDecode(response.toString());
    } catch (res) {
      String resStr = response.toString();
      if (resStr != null && resStr.contains('<!DOCTYPE html>')) {
        onSuccess({"res": resStr});
      } else {
        onSuccess(<String, dynamic>{});
      }
      return;
    }
    var code = resultData['body']['code'];
    String desc = resultData['body']['desc'];
    if (code == HttpCodeConstants.SUCCESS) {
      var content = resultData['body']['content'];
      if (content == null) {
        content = <String, dynamic>{};
      } else {
        if (content.runtimeType.toString() == '_InternalLinkedHashMap<String, dynamic>') {
          var message = content['message'];
          if (message != null && message.runtimeType.toString() == 'String') {
            var code = content['code'];
            if (code != null && (code.toString() != '0')) {
              onError({'code': code, 'desc': message});
              if (showErrorDialog == null || showErrorDialog == true) {
                XtmAlertDialog.show(NavigatorProvider.navigatorContext, message: message);
              }
            }
          }
        }
      }
      if (onSuccess != null) {
        if (responseReturnLevel == ResponseReturnLevel.BODY) {
          onSuccess(resultData['body']);
        } else if (responseReturnLevel == ResponseReturnLevel.FULL) {
          onSuccess(resultData);
        } else {
          onSuccess(content);
        }
      }
    } else if (code == HttpCodeConstants.TOKEN_INVALID) {
      if (desc != null) {
        showTokenInvalidateDialog();
      }
    } else if (code == HttpCodeConstants.NEED_UPDATE) {
      xtmHttp.needUpdateHandler();
    } else {
      String str = '';
      String codeStr = (code ?? '-1').toString();
      if (desc == null) {
        str = '未获取到数据($codeStr)';
      } else {
        str = desc;
      }
      onError({'code': code, 'desc': str});
      if (showErrorDialog == null || showErrorDialog == true) {
        XtmAlertDialog.show(NavigatorProvider.navigatorContext, message: desc);
      }
    }
  }
}
