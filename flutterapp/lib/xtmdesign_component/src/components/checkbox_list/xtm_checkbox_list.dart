import 'package:flutter/material.dart';
import '../../xtm_design_config.dart';

/// 复选框列表项的数据模型。
///
/// 用于定义 [XtmCheckboxList] 中每一项的唯一标识和显示文本。
class XtmCheckboxListModle {
  /// 选项的唯一标识 ID
  String id;

  /// 选项的显示标签
  String label;

  XtmCheckboxListModle({
    this.id,
    this.label,
  });
}

/// 复选框列表组件，支持多选和默认选中。
///
/// [XtmCheckboxList] 用于展示一个可滚动的复选框列表，
/// 用户可以通过点击行来选中或取消选中某一项。
/// 组件内部维护选中状态，并通过 [onValueChange] 回调将当前所有选中项的 ID 列表传递给父组件。
///
/// 示例：
/// ```dart
/// XtmCheckboxList(
///   list: [
///     XtmCheckboxListModle(id: '1', label: '选项一'),
///     XtmCheckboxListModle(id: '2', label: '选项二'),
///   ],
///   defaultSelectValues: ['1'], // 默认选中选项一
///   onValueChange: (values) {
///     print('当前选中的ID列表:  $ values');
///   },
/// )
/// ```
class XtmCheckboxList extends StatefulWidget {
  /// 复选框选项列表
  final List<XtmCheckboxListModle> list;

  /// 默认选中的 ID 列表
  final List<String> defaultSelectValues;

  /// 选中状态改变时的回调，返回当前所有选中项的 ID
  final ValueChanged<List<String>> onValueChange;

  XtmCheckboxList({
    Key key,
    this.list = const [],
    this.defaultSelectValues = const [],
    this.onValueChange,
  }) : super(key: key);

  @override
  State<XtmCheckboxList> createState() => _XtmCheckboxListState();
}

class _XtmCheckboxListState extends State<XtmCheckboxList> {
  List<String> selectedValues = [];

  @override
  void initState() {
    super.initState();
    selectedValues = widget.defaultSelectValues;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      itemCount: widget.list.length,
      separatorBuilder: (context, index) {
        return SizedBox(height: 8.0);
      },
      itemBuilder: (context, index) {
        return _buildItem(widget.list[index]);
      },
    );
  }

  Widget _buildItem(XtmCheckboxListModle item) {
    final bool isSelected = selectedValues.contains(item.id);
    return InkWell(
      child: Row(children: [
        Expanded(
          child: Text(
            item.label ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isSelected ? xtmDesignConfig.mainColor : xtmDesignConfig.mainTextColor,
            ),
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Icon(
          isSelected ? Icons.check_box : Icons.check_box_outline_blank,
          size: 20.0,
          color: isSelected ? xtmDesignConfig.mainColor : xtmDesignConfig.subTextColor,
        ),
        SizedBox(
          width: 4,
        ),
      ]),
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedValues.remove(item.id);
          } else {
            selectedValues.add(item.id);
          }
        });
        if (widget.onValueChange != null) {
          widget.onValueChange(selectedValues);
        }
      },
    );
  }
}
