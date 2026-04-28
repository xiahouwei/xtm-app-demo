import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

/// 文字按钮组件
///
/// 通用文本按钮组件，支持多种样式类型、是否朴素模式以及是否占满宽度。
/// [XtmTextButton] 带有水波纹效果的按钮，默认背景色为[XtmDesignConfig.mainColor]
///
/// 支持设置按钮文字、文字大小、文字颜色;
///
/// 支持设置按钮的圆角、边框、背景色、边框颜色、是否椭圆;
///
/// 支持通过 [type] 定义按钮风格（如主题色、错误色），
/// 并通过 [plain] 控制是否为朴素按钮（无背景，仅边框+文字色）。
///
/// 同时支持：
/// - [fullWidth] 控制按钮是否占满父容器宽度
/// - [isOval] 控制是否为椭圆按钮
/// - [borderRadius] 自定义圆角
/// - [padding] 内边距
///
/// 优先级说明：
/// - 当 [type] 不为空时，按钮颜色由内部规则统一计算
/// - 当 [type] 为空时，使用外部传入的 [textColor]、[backgroundColor]、[borderSideColor]
/// 示例：
/// ```dart
///  XtmTextButton(
///    text: '提交',
///    isLarge: true,
///    fontSize: 16.0,
///    enabled: isComplete,
///    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
///    onPressed: () => sendCode(countdownManager),
///  )
/// // 主题按钮
/// XtmTextButton(
///   text: '提交',
///   type: XtmTextButtonType.PRIMARY,
///   onPressed: () {},
/// )
///
/// // 错误按钮（红色）
/// XtmTextButton(
///   text: '删除',
///   type: XtmTextButtonType.ERROR,
///   onPressed: () {},
/// )
///
/// // 朴素按钮（仅边框+文字）
/// XtmTextButton(
///   text: '取消',
///   type: XtmTextButtonType.PRIMARY,
///   plain: true,
///   onPressed: () {},
/// )
///
/// // 占满宽度按钮
/// XtmTextButton(
///   text: '确认',
///   type: XtmTextButtonType.PRIMARY,
///   fullWidth: true,
///   onPressed: () {},
/// )
///
/// // 自定义颜色按钮（不使用 type）
/// XtmTextButton(
///   text: '自定义',
///   textColor: Colors.black,
///   backgroundColor: Colors.white,
///   borderSideColor: Colors.grey,
///   onPressed: () {},
/// )
/// ```

enum XtmTextButtonType {
  /// 主题色按钮
  PRIMARY,

  /// 红色按钮
  ERROR,
}

class XtmTextButtonColors {
  final Color textColor;
  final Color backgroundColor;
  final Color borderSideColor;
  XtmTextButtonColors({
    this.textColor,
    this.backgroundColor,
    this.borderSideColor,
  });
}

class XtmTextButton extends StatelessWidget {
  /// 按钮文字
  final String text;

  /// 文字颜色
  final Color textColor;

  /// 文字大小
  final double fontSize;

  /// 是否椭圆
  final bool isOval;

  /// 自定义宽度
  final double width;

  /// 自定义高度
  final double height;

  /// 背景色
  final Color backgroundColor;

  /// 边框颜色
  final Color borderSideColor;

  /// 圆角
  final double borderRadius;

  /// 是否禁用
  final bool disabled;

  /// 点击事件
  final VoidCallback onPressed;

  /// 自定义文字左侧图标
  final Widget leftIcon;

  /// 自定义文字右侧图标
  final Widget rightIcon;

  /// 水平内边距
  final num horizontalPadding;

  /// 按钮类型(默认颜色)
  final XtmTextButtonType type;

  /// 是否镂空
  final bool plain;

  /// 是否宽度撑满
  final bool fullWidth;

  XtmTextButton({
    Key key,
    this.onPressed,
    this.disabled = false,
    this.text = '水波纹按钮',
    this.textColor = Colors.white,
    this.fontSize = 15.0,
    this.backgroundColor,
    this.borderSideColor,
    this.borderRadius = 5.0,
    this.isOval = false,
    this.width,
    this.height,
    this.leftIcon,
    this.rightIcon,
    this.horizontalPadding = 12.0,
    this.type,
    this.plain = false,
    this.fullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    XtmTextButtonColors colors = createButtonColors();
    return SizedBox(
      width: fullWidth ? double.infinity : width ?? null,
      height: height ?? 48.0,
      child: TextButton(
        onPressed: disabled ? null : onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding.toDouble()),
          alignment: Alignment.center,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          primary: Colors.black87,
          backgroundColor: disabled
              ? xtmDesignConfig.disabledColor
              : colors.backgroundColor ?? xtmDesignConfig.mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isOval ? 200.0 : borderRadius),
            side: BorderSide(
              color: disabled
                  ? xtmDesignConfig.disabledColor
                  : colors.borderSideColor ?? xtmDesignConfig.mainColor,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            leftIcon ?? SizedBox(),
            leftIcon != null ? SizedBox(width: 5.0) : SizedBox(),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textColor,
                fontSize: fontSize,
              ),
            ),
            rightIcon ?? SizedBox(),
          ],
        ),
      ),
    );
  }

  XtmTextButtonColors createButtonColors() {
    if (type != null) {
      if (type == XtmTextButtonType.PRIMARY) {
        if (plain) {
          return XtmTextButtonColors(
            textColor: xtmDesignConfig.mainColor,
            backgroundColor: Colors.white,
            borderSideColor: xtmDesignConfig.mainColor,
          );
        }
        return XtmTextButtonColors(
          textColor: Colors.white,
          backgroundColor: xtmDesignConfig.mainColor,
          borderSideColor: xtmDesignConfig.mainColor,
        );
      }
      if (type == XtmTextButtonType.ERROR) {
        if (plain) {
          return XtmTextButtonColors(
            textColor: Color(0xFFF56C6C),
            backgroundColor: Colors.white,
            borderSideColor: Color(0xFFF56C6C),
          );
        }
        return XtmTextButtonColors(
          textColor: Colors.white,
          backgroundColor: Color(0xFFF56C6C),
          borderSideColor: Color(0xFFF56C6C),
        );
      }
    }
    return XtmTextButtonColors(
      textColor: textColor,
      backgroundColor: backgroundColor,
      borderSideColor: borderSideColor,
    );
  }
}
