import 'dart:io';

import 'package:flutter_proj/config/app_config.dart';
import 'package:flutter_proj/constants/common_constant.dart';
import 'package:flutter_proj/network/http_api.dart';
import 'package:flutter_proj/network/http_manager.dart';
import 'package:flutter_proj/network/tms_http_request.dart';
import 'package:flutter_proj/store/global_store.dart';

/// 登录相关接口
class AuthApi {
  /// 检查是否有新版本
  Future<T> checkVersion<T>() async => xtmHttpApi.get(HttpOptions(
        path: 'tms-setting/firmwareUpdate/checkVersion',
        showLoading: false,
      ));

  /// 登录:手机号+密码
  Future<T> loginByMobile<T>({params}) async => xtmHttpApi.post(HttpOptions(
        path: 'login',
        contentType: RequestContentType.APPLICATION_FORM,
        responseReturnLevel: ResponseReturnLevel.FULL,
        params: params,
      ));

  /// 查询是否展示图片验证码
  Future<T> showPicCapture<T>({String mobile}) async => xtmHttpApi.post(HttpOptions(
        path: 'registered',
        contentType: RequestContentType.APPLICATION_FORM,
        responseReturnLevel: ResponseReturnLevel.FULL,
        params: {'mobile': mobile},
      ));

  /// 获取验证码
  Future<T> getSmsCode<T>({Map<String, dynamic> params}) async => xtmHttpApi.post(HttpOptions(
        path: 'appCaptcha',
        contentType: RequestContentType.APPLICATION_FORM,
        responseReturnLevel: ResponseReturnLevel.FULL,
        params: params,
      ));

  /// 初始化密码
  Future<T> setPassword<T>({params}) async => xtmHttpApi.put(HttpOptions(
        requestBaseUrl: TmsHttpRequest.TMS_SERVER_PATH,
        path: 'initLoginPassword',
        params: params,
      ));

  /// 版本更新获取下载地址
  Future<T> versionUpdate<T>({params}) async => xtmHttpApi.post(HttpOptions(
        path: 'firmwareUpdate',
        contentType: RequestContentType.APPLICATION_FORM,
        params: params,
      ));

  /// 获取用户信息
  Future<T> getUserinfoAPi<T>({Map<String, dynamic> params, bool showLoading = true}) async =>
      xtmHttpApi.post(HttpOptions(
        path: 'getNoLoginUserInfo',
        contentType: RequestContentType.APPLICATION_FORM,
        params: params,
        showLoading: showLoading,
      ));

  /// 登录接口 token
  Future<T> getAuthTokenByMobileApi<T>({String mobile, params}) async => xtmHttpApi.get(HttpOptions(
        path: 'validata/smsCode/${mobile}',
        params: params,
      ));

  /// 是否设置了密码
  Future<T> isLoginPwdExists<T>({String userId}) async =>
      xtmHttpApi.get(HttpOptions(path: 'user/user/pwd/exists/$userId'));

  /// 注册获取手机验证码
  Future<T> getSmsCodeByMobileWithRegiste<T>({String mobile}) async =>
      xtmHttpApi.get(HttpOptions(path: 'validata/smsCode/${mobile}/11'));

  /// 注册
  Future<T> registerUser<T>({params}) async => xtmHttpApi.post(HttpOptions(
        path: 'app/sign-up/driver',
        params: params,
      ));

  /// 个推绑定cid
  Future<T> bindClientId<T>() async => xtmHttpApi.post(HttpOptions(
        path: 'msg/base/bindCid',
        params: {
          'clientId': xtmGlobalStore.auth.clientId,
          'userId': xtmGlobalStore.auth.userInfo.userID,
          'type': Platform.isIOS ? 1 : 2,
          'appChannel': AppConfig.APP_CHANNEL_NAME
        },
      ));

  /// 个推解绑cid
  Future<T> unbindClientId<T>() async => xtmHttpApi.post(HttpOptions(
        path: 'msg/base/unBindCid',
        params: {
          'clientId': xtmGlobalStore.auth.clientId,
          'userId': xtmGlobalStore.auth.userInfo.userID,
          'type': Platform.isIOS ? 1 : 2,
          'appChannel': AppConfig.APP_CHANNEL_NAME
        },
      ));

  /// 获取当前用户可以管理的企业
  Future<T> getManageCompanyList<T>() async => xtmHttpApi.post(HttpOptions(
        path: 'tms-company/company/getManageCompanyList',
        params: {
          'pageNum': 1,
          'pageSize': 9999,
          'companyCertificationState': -1,
          'organTypeIds': [CommonConstant.SHIPPER, CommonConstant.SHIPPER_AGENT]
        },
      ));

  /// 获取所选企业信息
  Future<T> getCurrentCompanyInfo<T>(String companyId) async => xtmHttpApi.get(
        HttpOptions(
          path: 'tms-company/company/$companyId/id',
        ),
      );
}
