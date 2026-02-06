/// Dialog按钮样式
/// normal  左右两个按钮
/// text 左右横向文字按钮，顶部和中间有分割线
enum XtmDialogButtonStyle {
  normal,
  text,
}

/// Dialog 类型
/// confirm 两个按钮， alert 一个按钮 默认留右边
enum XtmDialogType {
  confirm,
  alert,
}

/// dialog 按钮点击事件类型
enum XtmDialogAction {
  cancel,
  confirm,
}
