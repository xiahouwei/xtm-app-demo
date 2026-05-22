import 'package:flutter/material.dart';

/// 自定义分割线组件，对原生 [Divider] 的轻量封装。
///
/// [XtmDivider] 在保留原生分割线属性的基础上，
/// 新增了 [padding] 属性，方便开发者直接为分割线添加内边距，
/// 而无需额外嵌套 [Padding] 组件，使代码更加简洁。
///
/// 示例：
/// ```dart
/// // 带左右内边距的分割线
/// XtmDivider(
///   padding: EdgeInsets.symmetric(horizontal: 16.0),
///   thickness: 1.0,
///   color: Colors.grey,
/// )
/// ```

class XtmDivider extends StatelessWidget {
  /// 分割线的内边距
  final EdgeInsetsGeometry padding;

  /// 分割线的粗细（高度），默认为 1
  final double thickness;

  /// 分割线所占的总高度（包含间距），默认由系统决定
  final double height;

  /// 分割线的颜色
  final Color color;

  XtmDivider({
    this.padding,
    this.thickness = 1,
    this.color,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Divider divider = Divider(
      thickness: thickness,
      color: color,
      height: height,
    );
    if (padding != null) {
      return Padding(
        padding: padding,
        child: divider,
      );
    }
    return divider;
  }
}
