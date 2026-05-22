import 'package:flutter/material.dart';

/// [XtmStateTextTag] 带背景色的状态类文字展示控件,
/// 默认有五组颜色，使用时必须传入颜色枚举[StateColorEnum],
/// 支持自定义文本大小和 控件宽度，支持自定义圆角大小
///
/// 示例：
/// ```
///  XtmStateTextTag(
///      AuditStatusConstant.getStatusText(_userInfo.auditStatus),
///      AuditStatusConstant.getStateColorEnum(_userInfo.auditStatus),
///      fontSize: 12,
///      width: 60,
///  ),
/// ```

class XtmStateTextTag extends StatelessWidget {
  final String text;
  final StateColorEnum stateColor;
  final double width;
  final double fontSize;
  final BorderRadius borderRadius;

  XtmStateTextTag(
    this.text,
    this.stateColor, {
    this.width = 80.0,
    this.fontSize = 14.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(3)),
  });

  @override
  Widget build(BuildContext context) {
    ColorEntity entity = _createColor(stateColor);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      width: width,
      decoration: BoxDecoration(
        color: entity.bgColor,
        borderRadius: borderRadius,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: entity.mainColor, fontSize: fontSize, fontWeight: FontWeight.bold),
      ),
    );
  }

  ColorEntity _createColor(StateColorEnum color) {
    switch (color) {
      case StateColorEnum.STATE_RED:
        return ColorEntity(bgColor: Color(0x2AE43A2C), mainColor: Color(0xFFE43A2C));
        break;
      case StateColorEnum.STATE_ORANGE:
        return ColorEntity(bgColor: Color(0x2AFF7C0E), mainColor: Color(0xFFFF7C0E));
        break;
      case StateColorEnum.STATE_GREEN:
        return ColorEntity(bgColor: Color(0x2A2FB458), mainColor: Color(0xFF2FB458));
        break;
      case StateColorEnum.STATE_BLUE:
        return ColorEntity(bgColor: Color(0x2A337CF7), mainColor: Color(0xFF337CF7));
        break;
      case StateColorEnum.STATE_GRAY:
        return ColorEntity(bgColor: Color(0x2A9CA6BA), mainColor: Color(0xFF9CA6BA));
        break;
      default:
        return ColorEntity(bgColor: Color(0x2A6B6B6B), mainColor: Color(0xFF6B6B6B));
    }
  }
}

class ColorEntity {
  Color bgColor;
  Color mainColor;

  ColorEntity({this.bgColor, this.mainColor});
}

enum StateColorEnum {
  STATE_RED,
  STATE_ORANGE,
  STATE_GREEN,
  STATE_BLUE,
  STATE_GRAY,
}
