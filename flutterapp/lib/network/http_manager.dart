import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/network/http_response_code.dart';
import 'package:flutter_proj/network/http_traceid.dart';
import 'package:flutter_proj/network/tms_http_request.dart';
import 'package:flutter_proj/routes/app_router_constant.dart';
import 'package:flutter_proj/routes/route_navigator_observer.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/utils/navigator_provider_utils.dart';
import 'package:flutter_proj/widgets/show_invalidate_token_dialog.dart';
import 'package:flutter_proj/widgets/tms_loading.dart';
import 'package:flutter_proj/widgets/versionUpdateDialog/show_version_update_dialog.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

enum RequestMethodEnum {
  POST,
  GET,
  PUT,
  DELETE,
}

enum ResponseReturnLevel {
  DATA,
  BODY,
  FULL,
}

class RequestContentType {
  static String FORM_DATA = 'multipart/form-data';
  static String APPLICATION_FORM = 'application/x-www-form-urlencoded';
  static String APPLICATION_JSON = 'application/json';
}

Dio xtmDioHttp = Dio();

///拦截器
class HTTPInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    TmsLoading.dismiss();
    HTTPException exp = HTTPException.create(err);
    String msg = exp._message;
    int code = exp._code;
    if (code == 401) {
      if (err.response.data['code'] == 401 || err.response.data['msg'] == 'Not Authenticated') {
        showTokenInvalidateDialog();
      } else {
        msg = err.response.data['msg'];
        XtmToast.error(msg);
      }
    } else if (msg != null) {
      XtmToast.error(msg);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    print(response);
  }
}

///自定义异常
class HTTPException implements Exception {
  final String _message;
  final int _code;

  HTTPException([this._message, this._code]);

  factory HTTPException.create(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        return HTTPException('请求超时,请重试', -1);
      case DioErrorType.response:
        final statusCode = error.response?.statusCode ?? -1;
        final msg = error.response?.statusMessage ?? '网络波动,请重试';
        return HTTPException(statusCode == 401 ? '登录状态已失效,请重试' : msg, statusCode);
      default:
        return HTTPException(error.message ?? '网络波动,请重试', -100);
    }
  }

  @override
  String toString() => 'HTTPException(code: $_code, message: $_message)';
}

class HTTP {
  static final HTTP _instance = HTTP._internal();

  factory HTTP() => _instance;
  final Dio dioHttp = xtmDioHttp;
  final traceCounter = TraceidManage(version: '00', platform: 'NGJ-APP', traceFlag: '01');
  static const int TIMEOUT_MS = 40000;

  HTTP._internal() {
    dioHttp.interceptors.add(HTTPInterceptor());
    DefaultHttpClientAdapter httpClient = dioHttp.httpClientAdapter;
    httpClient.onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
      return client;
    };
    if (HTTPConfig.API_LOG) {
      dioHttp.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: false,
        maxWidth: 100,
      ));
    }
  }

  Map<String, dynamic> _setHeaders() {
    String platform = Platform.isIOS ? 'ios' : 'android';
    String apiVersion = HTTPConfig.apiVersion;
    String token = xtmGlobalStore.auth.token ?? '';
    String mobile = xtmGlobalStore.auth.userInfo.mobile ?? '';
    String trace = traceCounter.createTraceId(mobile);
    String terminal = HTTPConfig.terminal;
    return {
      'Authorization': token,
      'platform': platform,
      'version': apiVersion,
      'terminal': terminal,
      'treeId': trace,
    };
  }

  Future fireRequest({
    RequestMethodEnum requestMethod = RequestMethodEnum.POST,
    @required String path,
    dynamic params,
    Map<String, dynamic> queryParameters,
    String contentType,
    int connectTimeout,
    int receiveTimeout,
    Function(dynamic result) onSuccess,
    Function(Map<String, dynamic> result) onError,
    bool showLoading = true,
    bool showErrorDialog = true,
    ResponseType responseType,
    ResponseReturnLevel responseReturnLevel = ResponseReturnLevel.DATA,
  }) async {
    CancelFunc loadingDismissFunc;
    if (showLoading) {
      loadingDismissFunc = TmsLoading.showLoading();
    }

    String baseUrl = '';
    if (HTTPConfig.appType == HTTP_REQUEST_APP_TYPE.TMS &&
        contentType == RequestContentType.APPLICATION_FORM) {
      baseUrl = TmsHttpRequest.getBaseUrl();
    } else {
      baseUrl = '${HTTPConfig.serverDomain}${HTTPConfig.serverPath}';
    }
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      contentType: contentType ?? RequestContentType.APPLICATION_JSON,
      connectTimeout: connectTimeout ?? TIMEOUT_MS,
      receiveTimeout: receiveTimeout ?? TIMEOUT_MS,
      headers: _setHeaders(),
    );
    dioHttp.options = options;
    if (HTTPConfig.appType == HTTP_REQUEST_APP_TYPE.TMS &&
        contentType == RequestContentType.APPLICATION_FORM) {
      params = TmsHttpRequest.handleFormData(path: path, params: params);
    } else if (contentType == RequestContentType.FORM_DATA) {
      params = new FormData.fromMap(params);
    }

    var response;
    try {
      switch (requestMethod) {
        case RequestMethodEnum.POST:
          response = await dioHttp.post(path, data: params, queryParameters: queryParameters);
          break;
        case RequestMethodEnum.GET:
          response = await dioHttp.get(path, queryParameters: queryParameters);
          break;
        case RequestMethodEnum.PUT:
          response = await dioHttp.put(path, data: params, queryParameters: queryParameters);
          break;
        case RequestMethodEnum.DELETE:
          response = await dioHttp.delete(path, data: params, queryParameters: queryParameters);
          break;
        default:
          response = {};
      }
    } on DioError catch (e) {
      errorResponse(e, onError);
    }
    if (showLoading) {
      loadingDismissFunc?.call();
    }

    if (response == null) {
      return;
    }
    if (HTTPConfig.appType == HTTP_REQUEST_APP_TYPE.TMS &&
        contentType == RequestContentType.APPLICATION_FORM) {
      TmsHttpRequest.handleResponse(
        response,
        onSuccess,
        onError,
        showErrorDialog: showErrorDialog,
        responseType: responseType,
        responseReturnLevel: responseReturnLevel,
      );
    } else {
      _handleResponse(
        response,
        onSuccess,
        onError,
        showErrorDialog: showErrorDialog,
        responseType: responseType,
        responseReturnLevel: responseReturnLevel,
      );
    }
  }

  void errorResponse(DioError e, Function(Map<String, dynamic> result) onError) {
    HTTPException exception = HTTPException.create(e);
    onError({'code': exception._code, 'desc': exception._message});
  }

  void _handleResponse(
    Response response,
    Function(dynamic result) onSuccess,
    Function(Map<String, dynamic> result) onError, {
    bool showErrorDialog,
    ResponseType responseType,
    ResponseReturnLevel responseReturnLevel = ResponseReturnLevel.DATA,
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

    var code = resultData['code'].toString();
    String desc = resultData['message'];

    if (code.contains('200') || code == '0') {
      dynamic content = resultData['data'];
      if (onSuccess != null) {
        if (responseReturnLevel == ResponseReturnLevel.BODY) {
          onSuccess(resultData['body']);
        } else if (responseReturnLevel == ResponseReturnLevel.FULL) {
          onSuccess(resultData);
        } else {
          onSuccess(content);
        }
      }
    } else if (desc == 'App token失效' || desc == '您的登录已过期，请重新登录') {
      ///兼容code=-1不唯一情况，改为message判断 token失效
      showTokenInvalidateDialog();
    } else if (code == HttpCodeConstants.NEED_UPDATE) {
      needUpdateHandler();
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

  void needUpdateHandler() {
    String routeName = RouteNavigatorObserver().currentRouteName;
    if (routeName != null && routeName == AppRouterNameConstant.LOGIN) {
      showVersionUpdateDialog();
    } else {
      showTokenInvalidateDialog();
    }
  }
}

final xtmHttp = HTTP();
