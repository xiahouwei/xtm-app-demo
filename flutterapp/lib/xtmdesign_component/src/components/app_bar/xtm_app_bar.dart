import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

/// 标题栏 组件
/// [XtmAppBar] 支持自定义左侧返回按钮，右侧自定义组件集合，标题，背景色
/// 支持返回按钮带参数
///
/// 示例：
/// XtmAppBar(
///   title: '个人信息',
///   popParams: {'dataChanged': dataChanged},
///   rightActions: [
///      InkWell(
///         onTap: () {},
///         child: Text('保存'),
///      )
///  ],
/// )

class XtmAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// 标题
  final String title;

  /// 标题颜色
  final Color titleColor;

  /// 左侧自定义组件
  final Widget leftWidget;

  /// 右侧自定义组件集合
  final List<Widget> rightActions;

  /// 背景色
  final Color backgroundColor;

  /// 阴影
  final double elevation;

  /// pop事件携带的参数
  final Map<String, dynamic> popParams;

  XtmAppBar({
    Key key,
    this.title,
    this.titleColor,
    this.leftWidget,
    this.rightActions,
    this.backgroundColor,
    this.elevation,
    this.popParams,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(fontSize: 18, color: titleColor ?? xtmDesignConfig.mainTextColor),
      ),
      backgroundColor: backgroundColor ?? Colors.white,
      leading: leftWidget ??
          IconButton(
            onPressed: () {
              Navigator.pop(context, popParams);
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 28,
            ),
          ),
      actions: rightActions,
      elevation: elevation ?? 1.0,
      iconTheme: IconThemeData(color: xtmDesignConfig.mainTextColor),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
