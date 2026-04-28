import 'package:flutter/material.dart';

/// 主题资源配置基类，添加资源先添加到[BaseTheme]中
abstract class BaseTheme {
  /// 主题色
  Color get primaryColor;

  /// 页面渐变背景色
  LinearGradient get pageBgColor;

  /// 标题栏背景色
  Color get appBarColor;

  /// 主要文本颜色
  Color get mainTextColor;

  /// 次要文本颜色
  Color get subTextColor;

  /// 标题文本颜色
  Color get titleTextColor;

  /// 分割线颜色
  Color get dividerColor;

  /// 卡片背景色
  Color get cardBgColor;

  /// 未选中背景色
  Color get unSelectBgColor;
}
