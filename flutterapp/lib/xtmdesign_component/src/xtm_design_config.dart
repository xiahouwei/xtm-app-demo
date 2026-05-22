import 'package:flutter/material.dart';

/// XtmDesign 配置项
/// 可在程序初始化的时候进行配置，对组件库进行全局基础配置

class XtmDesignConfiguration {
  static final XtmDesignConfiguration _singleton = XtmDesignConfiguration._internal();

  factory XtmDesignConfiguration() => _singleton;

  XtmDesignConfiguration._internal();

  /// 主色
  Color mainColor = Color(0xFF439DFA);

  /// 主文本色
  Color mainTextColor = Colors.black87;

  /// 次文本色
  Color subTextColor = const Color(0xFF989898);

  /// 标题颜色
  Color titleTextColor = Color(0xFF646464);

  /// 禁用色
  Color disabledColor = Color(0xFFD6DAE1);

  /// 未选中色
  Color unSelectBgColor = Color(0xFFEEF2F4);

  /// 边框颜色
  Color dividerColor = Color(0xFFDEE3E9);

  /// 卡片类颜色
  Color cardBgColor = Colors.white;

  /// 字体缩放倍数
  double fontScale = 1.0;

  void config({Color mainColor, double fontScale}) {
    this.mainColor = mainColor ?? this.mainColor;
    this.fontScale = fontScale ?? this.fontScale;
  }
}

final XtmDesignConfiguration xtmDesignConfig = XtmDesignConfiguration();
