import 'package:flutter/material.dart';
import 'package:flutter_proj/routes/app_router_constant.dart';
import 'package:flutter_proj/routes/route_navigator_observer.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/utils/navigator_provider_utils.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

void showTokenInvalidateDialog({VoidCallback sureActionOnPress}) {
  String routeName = RouteNavigatorObserver().currentRouteName;
  if (routeName != null && routeName == AppRouterNameConstant.LOGIN) {
    return;
  }

  XtmAlertDialog.show(
    NavigatorProvider.navigatorContext,
    message: '您的登录已过期，请重新登录',
  ).then((action) {
    ///退出登录
    xtmGlobalStore.auth.setToken('');
    xtmGlobalStore.auth.setIsLogin(false);
    Navigator.pushNamedAndRemoveUntil(NavigatorProvider.navigatorContext,
        AppRouterNameConstant.LOGIN, ModalRoute.withName(AppRouterNameConstant.LOGIN));
    if (sureActionOnPress != null) {
      sureActionOnPress();
    }
  });
}
