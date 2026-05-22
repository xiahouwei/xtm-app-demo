import 'dart:async';

import 'package:flutter/material.dart';

import 'widgets/bottom_sheet_header.dart';

/// 底部弹出框选择器

class XtmCustomBottomSheet {
  /// 显示底部弹窗
  ///
  /// [title] 弹窗标题
  ///
  /// [height] 弹窗高度
  ///
  /// [isDismissible] 点击弹窗外是否可收回

  static Future<bool> showBottomSheet(
    BuildContext context, {
    String title,
    Widget customWidget,
    double height = 250.0,
    bool isDismissible = true,
  }) async {
    FocusScope.of(context).unfocus();
    final bool confirm = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      builder: (ctx) {
        return _XtmCustomBottomPickerContent(
          title: title,
          height: height,
          customWidget: customWidget,
        );
      },
    );
    if (confirm) {
      return Future.value();
    }
    return Future.error('取消');
  }
}

class _XtmCustomBottomPickerContent extends StatelessWidget {
  /// 标题
  final String title;

  /// 弹窗高度
  final double height;

  /// 自定义view
  final Widget customWidget;

  _XtmCustomBottomPickerContent({
    Key key,
    this.title,
    this.height,
    this.customWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(12.0),
          right: Radius.circular(12.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BottomSheetHeader(
            title: title,
            confirmAction: () => Navigator.pop(context, true),
          ),
          _buildHorizontalDivider(),
          Expanded(child: customWidget)
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
