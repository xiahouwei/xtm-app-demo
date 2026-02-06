import 'package:flutter/material.dart';

/// 默认带分割线，右侧带箭头的单元格组件
///
/// [XtmCell] 左右结构数据展示组件，支持自定义左右两边文字的 style,
/// 支持自定义左右两边的 widget，左边 widget 在文字前，右边 widget 在文字后，
/// 支持设置点击事件；
///
/// 支持自定义内边距，可设置必填属性（左侧带红色 *）
///
/// 示例：
/// ```
/// XtmCell(
///    label: '绑定信息',
///    value: '绑定了3家'
///    leftWidget: Icon(
///      Icons.link,
///      color: XtmColor.blue,
///      size: 16,
///    ),
///    verticalPadding: 8,
///    showRightArrow: false,
///    showDivider: false,
///    onCellTap: () {},
///  ),
/// ```

class XtmCell extends StatelessWidget {
  /// 左边label
  final String label;

  /// 右边value
  final String value;

  /// 是否必填
  final bool isRequired;

  /// 水平内边距
  final num horizontalPadding;

  /// 垂直内边距
  final num verticalPadding;

  /// 是否显示分割线
  final bool showDivider;

  /// 是否显示右边的箭头
  final bool showRightArrow;

  /// 最左边自定义的widget
  final Widget leftWidget;

  /// 最右边自定义的widget
  final Widget rightWidget;

  /// 左边label的样式
  final TextStyle labelStyle;

  /// 右边value的样式
  final TextStyle valueStyle;

  /// 点击cell的回调
  final Function() onCellTap;

  XtmCell({
    Key key,
    this.label,
    this.value,
    this.isRequired = false,
    this.showDivider = true,
    this.showRightArrow = true,
    this.leftWidget,
    this.rightWidget,
    this.horizontalPadding = 10.0,
    this.verticalPadding = 16.0,
    this.labelStyle,
    this.valueStyle,
    this.onCellTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding.toDouble(),
              vertical: verticalPadding.toDouble(),
            ),
            color: Color(0x02919191),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ..._buildLeftContent(),
                SizedBox(width: 10.0),
                ..._buildRightContent(),
              ],
            ),
          ),
          onTap: onCellTap != null
              ? () {
                  FocusScope.of(context).unfocus();
                  onCellTap();
                }
              : null,
        ),
        showDivider
            ? Divider(
                height: 1,
                thickness: 1, // 线粗细
                color: Colors.black12,
              )
            : SizedBox(),
      ],
    );
  }

  List<Widget> _buildLeftContent() {
    return [
      leftWidget != null ? leftWidget : SizedBox(),
      leftWidget != null ? SizedBox(width: 3.0) : SizedBox(),
      isRequired
          ? Text('*',
              strutStyle: StrutStyle(height: 1.5, leading: 0.0, forceStrutHeight: true),
              style: TextStyle(color: Colors.red))
          : SizedBox(),
      SizedBox(width: 3.0),
      Text(
        label,
        style: labelStyle ?? TextStyle(fontSize: 15.0, color: Colors.black87),
      ),
    ];
  }

  List<Widget> _buildRightContent() {
    return [
      Expanded(
        child: Text(
          value ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          style: valueStyle ?? TextStyle(fontSize: 15.0, color: Colors.black87),
        ),
      ),
      SizedBox(width: 5.0),
      rightWidget != null
          ? rightWidget
          : showRightArrow
              ? Icon(Icons.keyboard_arrow_right, size: 18.0, color: Colors.grey)
              : SizedBox(),
    ];
  }
}
