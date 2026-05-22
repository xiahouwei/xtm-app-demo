import 'package:flutter_proj/models/login/current_company_model.dart';
import 'package:flutter_proj/models/login/user_info_model.dart';

class AuthGlobalState {
  /// 登录状态
  bool isLogin;

  /// token
  String token;

  /// 版本号
  String version;

  /// 用户信息
  UserInfoModel userInfo;

  /// 用户名
  String userName;

  /// 密码
  String password;

  /// 是否显示隐私协议
  bool showSecretDialog;

  /// 当前基地
  String platformName;

  /// 个推客户端id
  String clientId;

  /// 当前管理的企业
  String currentCompanyId;

  /// 当前管理企业信息
  CurrentCompanyModel currentCompany;

  AuthGlobalState({
    this.isLogin,
    this.token,
    this.version,
    this.userInfo,
    this.userName,
    this.password,
    this.showSecretDialog,
    this.platformName,
    this.clientId,
    this.currentCompanyId,
    this.currentCompany,
  });
}
