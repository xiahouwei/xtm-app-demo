import 'package:flutter_proj/network/http_api.dart';

class MineApi {
  /// 修改姓名
  Future<T> updateUserName<T>(String name) async => xtmHttpApi.put(HttpOptions(
        path: 'user/app/driver/name',
        params: {'name': name},
      ));

  /// 修改身份证号
  Future<T> updateIdCardNum<T>(String idCardNum) async => xtmHttpApi.put(HttpOptions(
        path: 'user/app/driver/identity-card',
        params: {'identityCard': idCardNum},
      ));

  /// 发送验证码
  Future<T> getSmsCode<T>(String mobile, String smsCodeScene) async => xtmHttpApi.get(HttpOptions(
        path: 'validata/smsCode/$mobile/$smsCodeScene',
      ));

  /// 修改手机号
  Future<T> updatePhone<T>(String mobile, String smsCode) async => xtmHttpApi.put(HttpOptions(
        path: 'user/app/driver/mobile',
        params: {'mobile': mobile, 'smsCode': smsCode},
      ));

  /// 修改密码
  Future<T> updatePwd<T>(String oldPwd, String newPwd) async => xtmHttpApi.put(HttpOptions(
        path: 'user/user/password',
        params: {'oldPassword': oldPwd, 'newPassword': newPwd, 'confirmPassword': newPwd},
      ));

  /// 忘记密码
  Future<T> resetPwd<T>(String smsCode, String newPwd) async => xtmHttpApi.put(HttpOptions(
        path: 'user/user/forget-password',
        params: {'smsCode': smsCode, 'newPassword': newPwd, 'confirmPassword': newPwd},
      ));

  /// 绑定信息列表
  Future<T> bindInfoList<T>() async => xtmHttpApi.get(HttpOptions(
        path: 'user/app/driver/enterprises',
      ));
}
