import 'package:flutter/cupertino.dart';

/// XtmDesign 配置项
/// 可在程序初始化的时候进行配置，对组件库进行全局基础配置

class XtmDesignConfiguration {
  static final XtmDesignConfiguration _singleton = XtmDesignConfiguration._internal();

  factory XtmDesignConfiguration() => _singleton;

  XtmDesignConfiguration._internal();

  /// 主色
  Color mainColor = Color(0xFF439DFA);

  /// 主文本色
  Color mainTextColor = Color(0xFF333333);

  /// 字体缩放倍数
  double fontScale = 1.0;

  void config({Color mainColor, double fontScale}) {
    this.mainColor = mainColor ?? this.mainColor;
    this.fontScale = fontScale ?? this.fontScale;
  }
}

final XtmDesignConfiguration xtmDesignConfig = XtmDesignConfiguration();
