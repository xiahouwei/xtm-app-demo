import 'package:flutter/material.dart';
import 'package:flutter_proj/pages/login/login_page.dart';
import 'package:flutter_proj/pages/main/main_page.dart';
import 'package:flutter_proj/routes/app_router_constant.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    AppRouterNameConstant.LOGIN: (ctx) => LoginPage(),
    AppRouterNameConstant.MAIN: (ctx) => MainPage(),
  };
}
