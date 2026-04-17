import 'dart:async';

import 'package:flutter_proj/network/http_manager.dart';
import 'package:flutter_proj/utils/async_utils.dart';

class HttpOptions {
  String path;
  dynamic params;
  Map<String, dynamic> queryParameters;
  String contentType;
  int connectTimeout;
  int receiveTimeout;
  Function(dynamic) onSuccess;
  Function(Map<String, dynamic>) onError;
  bool showLoading;
  bool showErrorDialog;
  ResponseReturnLevel responseReturnLevel;
  String requestBaseUrl;

  HttpOptions({
    this.path = '',
    this.params,
    this.queryParameters,
    this.contentType,
    this.connectTimeout,
    this.receiveTimeout,
    this.onSuccess,
    this.onError,
    this.showLoading = true,
    this.showErrorDialog = true,
    this.responseReturnLevel = ResponseReturnLevel.DATA,
    this.requestBaseUrl,
  });
}

class HttpApi {
  Future<T> request<T>(
    HttpOptions httpOptions, {
    RequestMethodEnum requestMethod,
  }) async {
    return AsyncUtils.PromiseFunction<T>((promise) async {
      await xtmHttp.fireRequest(
        requestMethod: requestMethod,
        path: httpOptions.path,
        params: httpOptions.params,
        queryParameters: httpOptions.queryParameters,
        contentType: httpOptions.contentType,
        connectTimeout: httpOptions.connectTimeout,
        receiveTimeout: httpOptions.receiveTimeout,
        showLoading: httpOptions.showLoading,
        showErrorDialog: httpOptions.showErrorDialog,
        responseReturnLevel: httpOptions.responseReturnLevel,
        requestBaseUrl: httpOptions.requestBaseUrl,
        onSuccess: (data) {
          if (httpOptions.onSuccess != null) {
            dynamic res = httpOptions.onSuccess(data);
            promise.complete(res as T);
          } else {
            promise.complete(data as T);
          }
        },
        onError: (err) {
          httpOptions.onError?.call(err);
          promise.completeError(err);
        },
      );
    });
  }

  Future<T> post<T>(HttpOptions httpOptions) async {
    return request(httpOptions, requestMethod: RequestMethodEnum.POST);
  }

  Future<T> get<T>(HttpOptions httpOptions) async {
    return request(httpOptions, requestMethod: RequestMethodEnum.GET);
  }

  Future<T> put<T>(HttpOptions httpOptions) async {
    return request(httpOptions, requestMethod: RequestMethodEnum.PUT);
  }

  Future<T> del<T>(HttpOptions httpOptions) async {
    return request(httpOptions, requestMethod: RequestMethodEnum.DELETE);
  }
}

final xtmHttpApi = HttpApi();
