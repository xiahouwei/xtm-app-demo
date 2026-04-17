import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_proj/app_init/ui_init.dart';
import 'package:flutter_proj/common/ume_kit/ume_kit_manage.dart';
import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/routes/app_router_constant.dart';
import 'package:flutter_proj/routes/app_routes.dart';
import 'package:flutter_proj/routes/route_navigator_observer.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/theme/xtm_color.dart';
import 'package:flutter_proj/utils/navigator_provider_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await xtmGlobalStore.init();
  UiInit.init();
  await HTTPConfig.initHttpConfig();

  runApp(
    UmeKitPluginManager.instance.createApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return UiInit.buildUi(
      MaterialApp(
        title: 'OBD管理系统',
        initialRoute: _handleRedirect(),
        routes: AppRoutes.routes,
        navigatorKey: NavigatorProvider.navigatorKey,
        theme: ThemeData(
          primaryColor: XtmColor.themeColor,
          highlightColor: Color(0x00000000),
          splashColor: Color(0x00000000),
          textTheme: TextTheme(
            bodyText2: TextStyle(fontSize: 15.0, color: XtmColor.mainTextColor),
          ),
        ),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          RefreshLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('zh', 'CN'),
          const Locale('en', 'US'),
        ],
        navigatorObservers: [
          BotToastNavigatorObserver(),
          RouteNavigatorObserver(),
        ],
        builder: (context, child) {
          child = MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: xtmGlobalStore.system.fontScale),
            child: child,
          );
          return botToastBuilder(context, child);
        },
      ),
    );
  }

  /// 初始页面
  String _handleRedirect() {
    bool isLogin = xtmGlobalStore.auth.isLogin;
    if (!isLogin) {
      return AppRouterNameConstant.LOGIN;
    }
    return AppRouterNameConstant.MAIN;
  }
}
