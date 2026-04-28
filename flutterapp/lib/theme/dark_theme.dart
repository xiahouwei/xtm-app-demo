import 'package:flutter/material.dart';

import 'base_theme.dart';

/// 暗色主题
class DarkTheme with BaseTheme {
  DarkTheme._internal();

  static final DarkTheme _instance = DarkTheme._internal();

  factory DarkTheme() => _instance;

  @override
  Color get primaryColor => const Color(0xFF2978FD);

  @override
  LinearGradient get pageBgColor => LinearGradient(
        colors: [Colors.black, Colors.black],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  @override
  Color get appBarColor => const Color(0xFFE3EFFD);

  @override
  Color get mainTextColor => Colors.white;

  @override
  Color get subTextColor => Colors.white;

  @override
  Color get titleTextColor => Colors.white;

  @override
  Color get dividerColor => Colors.white;

  @override
  Color get cardBgColor => Colors.black38;

  @override
  Color get unSelectBgColor => Colors.white;
}

final xtmDarkTheme = DarkTheme();
