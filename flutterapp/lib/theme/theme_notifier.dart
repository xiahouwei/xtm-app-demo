import 'package:flutter/material.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

/// 主题状态通知器
class ThemeNotifier with ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  Color get primaryColor => getThemeColor(
        lightColor: xtmLightTheme.primaryColor,
        darkColor: xtmDarkTheme.primaryColor,
      );

  LinearGradient get pageBgColor => getThemeGradient(
        lightColor: xtmLightTheme.pageBgColor,
        darkColor: xtmDarkTheme.pageBgColor,
      );

  Color get appBarColor => getThemeColor(
        lightColor: xtmLightTheme.appBarColor,
        darkColor: xtmDarkTheme.appBarColor,
      );

  Color get mainTextColor => getThemeColor(
        lightColor: xtmLightTheme.mainTextColor,
        darkColor: xtmDarkTheme.mainTextColor,
      );

  Color get subTextColor => getThemeColor(
        lightColor: xtmLightTheme.subTextColor,
        darkColor: xtmDarkTheme.subTextColor,
      );

  Color get titleTextColor => getThemeColor(
        lightColor: xtmLightTheme.titleTextColor,
        darkColor: xtmDarkTheme.titleTextColor,
      );

  Color get dividerColor => getThemeColor(
        lightColor: xtmLightTheme.dividerColor,
        darkColor: xtmDarkTheme.dividerColor,
      );

  Color get cardBgColor => getThemeColor(
        lightColor: xtmLightTheme.cardBgColor,
        darkColor: xtmDarkTheme.cardBgColor,
      );

  Color get unSelectBgColor => getThemeColor(
        lightColor: xtmLightTheme.unSelectBgColor,
        darkColor: xtmDarkTheme.unSelectBgColor,
      );

  /// 获取主题颜色
  Color getThemeColor({Color lightColor, Color darkColor}) {
    return isDark ? darkColor : lightColor;
  }

  /// 获取主题渐变颜色
  Gradient getThemeGradient({LinearGradient lightColor, LinearGradient darkColor}) {
    return isDark ? darkColor : lightColor;
  }

  /// 获取主题图片
  Image getThemeImage({Image lightImage, Image darkImage}) {
    return isDark ? darkImage : lightImage;
  }
}
