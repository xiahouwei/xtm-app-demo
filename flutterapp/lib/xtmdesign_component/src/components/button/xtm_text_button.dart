import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

/// 文字按钮组件
///
/// [XtmTextButton] 带有水波纹效果的按钮，默认背景色为[XtmDesignConfig.mainColor]
///
/// 支持设置按钮文字、文字大小、文字颜色;
///
/// 支持设置按钮的圆角、边框、背景色、边框颜色、是否椭圆;
///
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
/// ```

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

  /// 是否可点击
  final bool enabled;

  /// 点击事件
  final VoidCallback onPressed;

  /// 自定义文字左侧图标
  final Widget leftIcon;

  /// 自定义文字右侧图标
  final Widget rightIcon;

  /// 水平内边距
  final num horizontalPadding;

  XtmTextButton({
    Key key,
    this.onPressed,
    this.enabled = true,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? null,
      height: height ?? 48.0,
      child: TextButton(
        onPressed: enabled ? onPressed : null,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding.toDouble()),
          alignment: Alignment.center,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          primary: Colors.black87,
          backgroundColor:
              enabled ? backgroundColor ?? xtmDesignConfig.mainColor : xtmDesignConfig.enableColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isOval ? 200.0 : borderRadius),
            side: BorderSide(
              color: enabled
                  ? borderSideColor ?? xtmDesignConfig.mainColor
                  : xtmDesignConfig.enableColor,
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
                color: textColor,
                fontSize: fontSize,
              ),
            ),
            rightIcon ?? SizedBox(),
          ],
        ),
      ),
    );
  }
}
