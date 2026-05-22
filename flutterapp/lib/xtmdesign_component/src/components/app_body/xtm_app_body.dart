import 'package:flutter/material.dart';

/// 页面通用 Body 容器组件，用于统一页面内容区域布局。
///
/// [XtmAppBody] 主要用于包裹页面主体内容（body），
/// 提供统一的宽度填充、安全区域处理、内边距以及背景样式。
///
/// 功能特性：
/// - 自动设置宽度、高度为 100%（填满父容器）
/// - 可选开启 [SafeArea]，避免刘海屏/底部手势区域遮挡
/// - 支持统一内边距 [padding]
/// - 支持渐变背景 [backgroundColor]
///
/// 示例:
/// ```dart
/// Scaffold(
///   appBar: AppBar(title: Text('示例')),
///   body: XtmAppBody(
///     backgroundColor: _theme.pageBgColor,
///     child: Column(
///       children: [
///         Text('内容1'),
///         Text('内容2'),
///       ],
///     ),
///   ),
/// )
/// ```

class XtmAppBody extends StatelessWidget {
  /// 内容
  final Widget child;

  /// padding
  final EdgeInsetsGeometry padding;

  /// 背景色
  final LinearGradient backgroundColor;

  XtmAppBody({
    Key key,
    @required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: double.infinity,
      height: double.infinity,
      padding: padding,
      decoration: BoxDecoration(gradient: backgroundColor),
      child: SafeArea(child: child),
    );

    return content;
  }
}
