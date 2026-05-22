import 'dart:convert';

import 'package:flutter_proj/models/login/current_company_model.dart';
import 'package:flutter_proj/models/login/user_info_model.dart';
import 'package:flutter_proj/store/auth/state.dart';
import 'package:flutter_proj/store/global_store_base.dart';
import 'package:flutter_proj/store/local_storage.dart';

class AuthStoreConstants {
  static const String KEY_IS_LOGIN = "isLogin";
  static const String KEY_USERINFO = "userInfo";
  static const String KEY_TOKEN = "token";
  static const String KEY_VERSION = "version";
  static const String KEY_USERNAME = "userName";
  static const String KEY_PASSWORD = "password";
  static const String KEY_SHOW_SECRET = "showSecretDialog";
  static const String KEY_PLATFORM_NAME = "platformName";
  static const String KEY_CLIENT_ID = "clientId";
  static const String KEY_CURRENT_COMPANY_ID = "currentCompanyId";
  static const String KEY_CURRENT_COMPANY_INFO = "currentCompanyInfo";
}

class AuthGlobalStore extends GlobalStoreBase<AuthGlobalState> {
  AuthGlobalStore();

  @override
  AuthGlobalState state = AuthGlobalState();

  @override
  Future<void> init() async {
    state.isLogin = await LocalStorage.getBool(AuthStoreConstants.KEY_IS_LOGIN, false);
    state.userInfo = await getUserInfoByLocalStorage();
    state.token = await LocalStorage.get(AuthStoreConstants.KEY_TOKEN, '');
    state.version = await LocalStorage.get(AuthStoreConstants.KEY_VERSION, '');
    state.userName = await LocalStorage.get(AuthStoreConstants.KEY_USERNAME, '');
    state.password = await LocalStorage.get(AuthStoreConstants.KEY_PASSWORD, '');
    state.showSecretDialog = await LocalStorage.getBool(AuthStoreConstants.KEY_SHOW_SECRET, true);
    state.platformName = await LocalStorage.get(AuthStoreConstants.KEY_PLATFORM_NAME, '');
    state.clientId = await LocalStorage.get(AuthStoreConstants.KEY_CLIENT_ID, '');
    state.currentCompanyId = await LocalStorage.get(AuthStoreConstants.KEY_CURRENT_COMPANY_ID, '');
    state.currentCompany = await getCurrentCompanyByLocalStorage();
  }

  bool get isLogin => state.isLogin;

  void setIsLogin(bool value) {
    state.isLogin = value;
    LocalStorage.set(AuthStoreConstants.KEY_IS_LOGIN, value);
  }

  Future<UserInfoModel> getUserInfoByLocalStorage() async {
    String userInfoJsonStr = await await LocalStorage.get(AuthStoreConstants.KEY_USERINFO, '');
    if (userInfoJsonStr == null || userInfoJsonStr.isEmpty) {
      return Future.value(UserInfoModel.fromJson({}));
    }
    return UserInfoModel.fromJson(jsonDecode(userInfoJsonStr) ?? {});
  }

  UserInfoModel get userInfo => state.userInfo;

  void setUserInfo(UserInfoModel value) {
    state.userInfo = value;
    LocalStorage.set(AuthStoreConstants.KEY_USERINFO, jsonEncode(value.toJson()));
  }

  String get token => state.token;

  void setToken(String value) {
    state.token = value;
    LocalStorage.set(AuthStoreConstants.KEY_TOKEN, value);
  }

  String get version => state.version;

  void setVersion(String value) {
    state.version = value;
    LocalStorage.set(AuthStoreConstants.KEY_VERSION, value);
  }

  String get userName => state.userName;

  void setUserName(String value) {
    state.userName = value;
    LocalStorage.set(AuthStoreConstants.KEY_USERNAME, value);
  }

  String get password => state.password;

  void setPassword(String value) {
    state.password = value;
    LocalStorage.set(AuthStoreConstants.KEY_PASSWORD, value);
  }

  bool get showSecretDialog => state.showSecretDialog;

  void setShowSecretDialog(bool value) {
    state.showSecretDialog = value;
    LocalStorage.set(AuthStoreConstants.KEY_SHOW_SECRET, value);
  }

  String get platformName => state.platformName;

  void setPlatformName(String domain) {
    state.platformName = domain;
    LocalStorage.set(AuthStoreConstants.KEY_PLATFORM_NAME, domain);
  }

  String get clientId => state.clientId;

  void setClientId(String clientId) {
    state.clientId = clientId;
    LocalStorage.set(AuthStoreConstants.KEY_CLIENT_ID, clientId);
  }

  String get currentCompanyId => state.currentCompanyId;

  void setCurrentCompanyId(String currentCompanyId) {
    state.currentCompanyId = currentCompanyId;
    LocalStorage.set(AuthStoreConstants.KEY_CURRENT_COMPANY_ID, currentCompanyId);
  }

  Future<CurrentCompanyModel> getCurrentCompanyByLocalStorage() async {
    String companyInfoJson =
        await await LocalStorage.get(AuthStoreConstants.KEY_CURRENT_COMPANY_INFO, '');
    if (companyInfoJson == null || companyInfoJson.isEmpty) {
      return Future.value(CurrentCompanyModel.fromJson({}));
    }
    return CurrentCompanyModel.fromJson(jsonDecode(companyInfoJson) ?? {});
  }

  CurrentCompanyModel get currentCompany => state.currentCompany;

  void setCurrentCompanyInfo(CurrentCompanyModel value) {
    state.currentCompany = value;
    LocalStorage.set(AuthStoreConstants.KEY_CURRENT_COMPANY_INFO,
        value == null ? '' : jsonEncode(value.toJson()));
  }
}
