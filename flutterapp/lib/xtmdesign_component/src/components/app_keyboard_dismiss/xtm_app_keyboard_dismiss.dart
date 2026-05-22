import 'package:flutter/material.dart';

/// 全局键盘收起组件，用于在点击空白区域时自动收起键盘。
///
/// [XtmAppKeyboardDismiss] 通常包裹在应用的最外层（如 MaterialApp 的 home 或 Scaffold 的 body），
/// 通过监听全局的点击手势，在用户点击非输入区域时触发 [FocusManager] 的 unfocus 方法，
/// 从而优雅地收起软键盘，提升用户体验。
///
/// 示例：
/// ```dart
/// XtmAppKeyboardDismiss(
///   child: Scaffold(
///     body: TextField(
///       decoration: InputDecoration(hintText: '点击空白处收起键盘'),
///     ),
///   ),
/// )
/// ```

class XtmAppKeyboardDismiss extends StatelessWidget {
  /// 子组件内容
  final Widget child;

  const XtmAppKeyboardDismiss({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
