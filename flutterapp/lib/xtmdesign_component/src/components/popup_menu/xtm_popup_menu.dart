import 'package:flutter/material.dart';

/// [XtmPopUpMenu] 菜单弹出组件,通常用于弹出悬浮菜单,进行快捷操作
///
/// 示例：
/// ```dart
/// XtmPopUpMenu(
///       icon: Icon(Icons.add, color: _theme.primaryColor),
///      items: [
///         XtmPopUpMenuItemModel(
///             label: '常用路线',
///             value: 'commonRoute',
///             onTap: () {
///               XtmToast.info('功能正在建设中，敬请期待');
///             }),
///       ],
///     );
///
/// ```

class XtmPopUpMenu extends StatefulWidget {
  /// 菜单锚定图标
  final Widget icon;
  final List<XtmPopUpMenuItemModel> items;

  XtmPopUpMenu({
    Key key,
    this.icon,
    this.items,
  }) : super(key: key);

  @override
  State<XtmPopUpMenu> createState() => _XtmPopMenuState();
}

class _XtmPopMenuState extends State<XtmPopUpMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.black.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      offset: Offset(0, 45),
      icon: widget.icon,
      onSelected: (String value) {
        XtmPopUpMenuItemModel item = widget.items.firstWhere((element) => element.value == value);
        item.onTap();
      },
      itemBuilder: (BuildContext context) => List.generate(
        widget.items.length,
        (index) => PopupMenuItem<String>(
          value: widget.items[index].value,
          textStyle: TextStyle(
            fontSize: 14,
            color: widget.items[index].textColor ?? Colors.white,
          ),
          child: Center(
            child: Text(widget.items[index].label),
          ),
        ),
      ),
    );
  }
}

class XtmPopUpMenuItemModel {
  /// 标签
  String label;

  /// 选中值
  String value;

  /// 文字颜色
  Color textColor;

  /// 点击事件
  Function onTap;

  XtmPopUpMenuItemModel({
    @required this.label,
    @required this.value,
    this.textColor,
    this.onTap,
  });
}
