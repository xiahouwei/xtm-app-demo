import 'package:flutter/material.dart';
import 'package:flutter_proj/routes/app_router_constant.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/utils/navigator_provider_utils.dart';

class AuthManager {
  /// 清除登录状态跳转登录页
  static void clearToLogin() {
    xtmGlobalStore.auth.setToken('');
    xtmGlobalStore.auth.setIsLogin(false);
    Navigator.pushNamedAndRemoveUntil(NavigatorProvider.navigatorContext,
        AppRouterNameConstant.LOGIN, ModalRoute.withName(AppRouterNameConstant.LOGIN));
  }
}
