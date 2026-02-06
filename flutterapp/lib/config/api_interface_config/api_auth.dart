import 'package:flutter_proj/network/http_api.dart';
import 'package:flutter_proj/network/http_manager.dart';

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

  /// 版本更新获取下载地址
  Future<T> versionUpdate<T>({params}) async => xtmHttpApi.post(HttpOptions(
        path: 'firmwareUpdate',
        contentType: RequestContentType.APPLICATION_FORM,
        params: params,
      ));

  /// 获取用户信息
  Future<T> getUserinfoAPi<T>({params}) async => xtmHttpApi.post(HttpOptions(
        path: 'getNoLoginUserInfo',
        contentType: RequestContentType.APPLICATION_FORM,
        params: params,
      ));

  /// 登录接口 token
  Future<T> getAuthTokenByMobileApi<T>({String mobile, params}) async => xtmHttpApi.get(HttpOptions(
        path: 'validata/smsCode/${mobile}',
        params: params,
      ));

  /// 是否设置了密码
  Future<T> isLoginPwdExists<T>({String userId}) async =>
      xtmHttpApi.get(HttpOptions(path: 'user/user/pwd/exists/$userId'));

  /// 设置密码
  Future<T> setPassword<T>({params}) async => xtmHttpApi.post(HttpOptions(
        path: 'user/user/pwd',
        params: params,
      ));

  /// 注册获取手机验证码
  Future<T> getSmsCodeByMobileWithRegiste<T>({String mobile}) async =>
      xtmHttpApi.get(HttpOptions(path: 'validata/smsCode/${mobile}/11'));

  /// 注册
  Future<T> registerUser<T>({params}) async => xtmHttpApi.post(HttpOptions(
        path: 'app/sign-up/driver',
        params: params,
      ));
}
