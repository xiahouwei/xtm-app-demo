import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_proj/app_init/ui_init.dart';
import 'package:flutter_proj/common/ume_kit/ume_kit_manage.dart';
import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/routes/app_router_constant.dart';
import 'package:flutter_proj/routes/app_routes.dart';
import 'package:flutter_proj/routes/route_navigator_observer.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/theme/theme_notifier.dart';
import 'package:flutter_proj/utils/navigator_provider_utils.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await xtmGlobalStore.init();
  UiInit.init();
  await HTTPConfig.initHttpConfig();

  runApp(UmeKitPluginManager.instance.createApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
      ],
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeNotifier xtmTheme = context.watch<ThemeNotifier>();
    final botToastBuilder = BotToastInit();
    return UiInit.buildUi(
      MaterialApp(
        title: '小铁马货主端',
        initialRoute: _handleRedirect(),
        routes: AppRoutes.routes,
        navigatorKey: NavigatorProvider.navigatorKey,
        themeMode: ThemeMode.light,
        theme: ThemeData(
          dividerTheme: DividerThemeData(color: xtmTheme.dividerColor, thickness: 1.0),
          textTheme: TextTheme(
            bodyText2: TextStyle(fontSize: 15.0, color: xtmTheme.mainTextColor),
          ),
        ),
        darkTheme: ThemeData(
          dividerTheme: DividerThemeData(color: xtmTheme.dividerColor, thickness: 1.0),
          textTheme: TextTheme(
            bodyText2: TextStyle(fontSize: 15.0, color: xtmTheme.mainTextColor),
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
