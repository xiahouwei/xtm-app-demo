import 'package:flutter/material.dart';

import 'base_theme.dart';

/// 亮色主题
class LightTheme with BaseTheme {
  LightTheme._internal();

  static final LightTheme _instance = LightTheme._internal();

  factory LightTheme() => _instance;

  @override
  Color get primaryColor => const Color(0xFF2978FD);

  @override
  LinearGradient get pageBgColor => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFE3EFFD),
          Color(0xFFF0F4F8),
          Color(0xFFF0F4F8),
        ],
        stops: [0.0, 0.3, 1.0],
      );

  @override
  Color get appBarColor => const Color(0xFFE3EFFD);

  @override
  Color get mainTextColor => Colors.black87;

  @override
  Color get subTextColor => const Color(0xFF989898);

  @override
  Color get titleTextColor => const Color(0xFF646464);

  @override
  Color get dividerColor => const Color(0xFFDEE3E9);

  @override
  Color get cardBgColor => Colors.white;

  @override
  Color get unSelectBgColor => const Color(0xFFEEF2F4);

}

final xtmLightTheme = LightTheme();
