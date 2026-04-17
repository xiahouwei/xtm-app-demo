import 'dart:async';

import 'package:flutter/material.dart';

import 'widgets/bottom_sheet_header.dart';
import 'widgets/custom_picker.dart';

/// 底部弹出框选择器
///
/// [XtmBottomSheet.showBottomPicker]
/// 传入一组 String 类型的 name 集合，用于展示，
/// 如果本地定义数据集，可参考 [EmissionStandardConstants]，继承自 [BottomSheetBase]，
/// 使用时在 initState() 中初始化 name 集合 和 数据集合。
///
/// 示例：
/// ```dart
///  EmissionStandardConstants emissionStandardConstants = EmissionStandardConstants();
///  emissionStandardNameList = emissionStandardConstants.sheetNames;
///  emissionStandardModelList = emissionStandardConstants.sheetModelList;
///
/// XtmBottomSheet.showBottomPicker(
///      context,
///      title: '排放标准',
///      data: emissionStandardNameList,
///      selectItem: _requestModel.emissionStandardStr ?? '',
/// ).then((index) {
///   setState(() {
///      _requestModel.emissionStandard = emissionStandardModelList[index].id;
///      _requestModel.emissionStandardStr = emissionStandardModelList[index].name;
///   });
/// });
/// ```

class XtmBottomSheet {
  /// 显示底部弹窗
  ///
  /// [data] 数据源集合 - 用于展示的选择项列表
  ///
  /// [selectItem] 当前选中项
  ///
  /// [title] 弹窗标题
  ///
  /// [height] 弹窗高度
  ///
  /// [isDismissible] 点击弹窗外是否可收回

  static Future<int> showBottomPicker(
    BuildContext context, {
    @required List<String> data,
    String selectItem,
    String title,
    double height = 250.0,
    bool isDismissible = true,
  }) async {
    FocusScope.of(context).unfocus();
    final int selectIndex = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      builder: (ctx) {
        return _XtmBottomPickerContent(
          data: data,
          selectItem: selectItem,
          title: title,
          height: height,
        );
      },
    );
    return Future.value(selectIndex);
  }
}

class _XtmBottomPickerContent extends StatefulWidget {
  /// 数据源集合
  final List<String> data;

  /// 选中项
  final String selectItem;

  /// 标题
  final String title;

  /// 弹窗高度
  final double height;

  const _XtmBottomPickerContent({
    @required this.data,
    this.selectItem,
    this.title,
    this.height,
  });

  @override
  State<_XtmBottomPickerContent> createState() => _XtmPickerBottomSheetState();
}

class _XtmPickerBottomSheetState extends State<_XtmBottomPickerContent> {
  int _index = 0;
  double borderRadius = 12.0;

  @override
  void initState() {
    super.initState();

    /// 初始化选中项
    if (widget.selectItem != null && widget.selectItem.isNotEmpty) {
      _index = widget.data.indexOf(widget.selectItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(borderRadius),
          right: Radius.circular(borderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BottomSheetHeader(
            title: widget.title,
            confirmAction: () => Navigator.pop(context, _index),
          ),
          _buildHorizontalDivider(),
          Expanded(
            child: CustomPicker(
              data: widget.data,
              selectedIndex: _index,
              onSelectedItemChanged: (index) {
                setState(() {
                  _index = index;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHorizontalDivider() {
    return Container(
      width: double.infinity,
      height: 1.0,
      color: Color(0xFFE8E8E8),
    );
  }
}
