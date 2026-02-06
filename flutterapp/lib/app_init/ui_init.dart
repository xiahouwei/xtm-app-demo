import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_proj/theme/xtm_color.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UiInit {
  static void init() {
    setStateBar();
    xtmDesignConfig.config(mainColor: XtmColor.themeColor);
  }

  static void setStateBar() {
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }

  static RefreshConfiguration initRefreshConfiguration(MaterialApp app) {
    return RefreshConfiguration(
      headerBuilder: () => ClassicHeader(
        textStyle: TextStyle(color: Colors.black),
        refreshingIcon: SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation(
              XtmColor.themeColor,
            ),
          ),
        ),
        failedIcon: const Icon(Icons.error, color: Colors.black),
        completeIcon: const Icon(Icons.done, color: Colors.black),
        idleIcon: const Icon(Icons.arrow_downward, color: Colors.black),
        releaseIcon: const Icon(Icons.refresh, color: Colors.black),
      ),
      footerBuilder: () => ClassicFooter(
        loadStyle: LoadStyle.ShowWhenLoading,
        loadingIcon: SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation(
              XtmColor.themeColor,
            ),
          ),
        ),
      ),
      headerTriggerDistance: 60.0,
      enableScrollWhenRefreshCompleted: true,
      //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
      enableLoadingWhenFailed: true,
      //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
      hideFooterWhenNotFull: false,
      child: app,
    );
  }

  static RefreshConfiguration buildUi(MaterialApp app) {
    return initRefreshConfiguration(app);
  }
}
