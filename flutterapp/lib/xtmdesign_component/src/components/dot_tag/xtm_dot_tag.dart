import 'package:flutter/material.dart';

/// 消息红点或角标组件，用于展示未读消息数量。
///
/// [XtmDotTag] 根据传入的 [count] 数量自动判断显示样式：
/// - 当 [count] 为 null 或小于等于 0 时，组件自动隐藏。
/// - 当 [count] 大于 99 时，显示为 "99+"。
/// - 其他情况直接显示具体数字。
///
/// 示例：
/// ```dart
/// // 显示数字 5
/// XtmDotTag(count: 5)
///
/// // 显示 99+
/// XtmDotTag(count: 120)
///
/// // 自动隐藏
/// XtmDotTag(count: 0)
/// ```
class XtmDotTag extends StatelessWidget {
  final int count;
  const XtmDotTag({
    Key key,
    @required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: count != null && count > 0,
      child: Container(
        alignment: Alignment.center,
        height: 18,
        decoration: BoxDecoration(
            color: Color(0xFFFA3434), borderRadius: BorderRadius.all(Radius.circular(9))),
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          '${setCount(count)}',
          style: TextStyle(fontSize: 10, color: Colors.white),
          textScaleFactor: 1.0,
        ),
      ),
    );
  }

  String setCount(int count) {
    if (count == null) return '';
    if (count > 99) {
      return '99+';
    }
    return count.toString();
  }
}
