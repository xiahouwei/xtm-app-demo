import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

/// [XtmConfirmDialog] 取消、确认对话框
/// 支持自定义内容区域，支持自定义按钮样式及颜色，
/// 内容区自定义支持 TextFormField 组件表单自动验证（需要传入 [formKey]）
///
/// 示例：
/// ```
///  XtmConfirmDialog.show(
///       context,
///       title: '修改手机号',
///       rightBtnTitle: '确认修改',
///       formKey: _formKey,
///       customContent: UpdatePhoneDialogContent(),
///     ).then((value) => {
///       右侧按钮点击事件
///     }).catchError((cancel) => {
///       左侧按钮点击事件
///  });
/// ```

class XtmConfirmDialog {
  static Future<void> show(
    BuildContext context, {
    String title,
    String message,
    Widget customContent,
    String leftBtnTitle,
    Color leftBtnTitleColor,
    String rightBtnTitle,
    Color rightBtnTitleColor,
    bool showCloseIcon = false,
    bool barrierDismissible = false,
    XtmDialogButtonStyle buttonStyle = XtmDialogButtonStyle.text,

    /// 当自定义组件中有 Form组件时，需要传入 key，点击确定按钮时，会进行自动验证
    GlobalKey<FormState> formKey,
  }) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CustomDialogWidget(
        formKey: formKey,
        title: title,
        message: message,
        leftBtnTitle: leftBtnTitle,
        rightBtnTitle: rightBtnTitle,
        rightBtnTitleColor: rightBtnTitleColor,
        customContent: customContent,
        showCloseIcon: showCloseIcon,
        buttonStyle: buttonStyle,
        dialogType: XtmDialogType.confirm,
      ),
    );
    if (action == XtmDialogAction.confirm) {
      return Future.value('');
    } else {
      return Future.error(XtmDialogAction.cancel);
    }
  }
}
