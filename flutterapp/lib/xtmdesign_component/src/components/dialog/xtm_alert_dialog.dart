import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

/// [XtmAlertDialog] 只有一个动作按钮的对话框
/// 支持自定义内容区域，支持自定义按钮样式及颜色，
/// 内容区自定义支持 TextFormField 组件表单自动验证（需要传入 [formKey]）
///
/// 示例：
/// ```
///  XtmAlertDialog.show(
///      context,
///      message: '您的登录已过期，请重新登录',
///    ).then((action) {  }
///  );
/// ```

class XtmAlertDialog {
  static Future<void> show(
    BuildContext context, {
    String title,
    String message,
    Widget customContent,
    String rightBtnTitle,
    Color rightBtnTitleColor,
    bool showDialogButton = true,
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
        title: title,
        message: message,
        rightBtnTitle: rightBtnTitle,
        rightBtnTitleColor: rightBtnTitleColor,
        customContent: customContent,
        formKey: formKey,
        buttonStyle: buttonStyle,
        dialogType: XtmDialogType.alert,
        showCloseIcon: showCloseIcon,
        showDialogButton: showDialogButton,
      ),
    );
    if (action == XtmDialogAction.confirm) {
      return Future.value('');
    }
  }
}
