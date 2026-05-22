import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../empty_view/xtm_empty.dart';

class XtmHtmWidget extends StatelessWidget {
  /// 内容
  final String html;

  /// 文字样式
  final TextStyle textStyle;

  XtmHtmWidget({
    Key key,
    @required this.html,
    this.textStyle = const TextStyle(fontSize: 15, height: 1.5),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isEmptyContent(html)
        ? XtmEmptyView()
        : HtmlWidget(
            html,
            textStyle: TextStyle(fontSize: 15, height: 1.5),
          );
  }

  bool isEmptyContent(String html) {
    if (html == null || html.trim().isEmpty) return true;
    String cleaned = html.replaceAll(
      RegExp(r'<p>(\s|&nbsp;|<br\s*/?>)*<\/p>', caseSensitive: false),
      '',
    );
    cleaned = cleaned.replaceAll(RegExp(r'\s'), '');
    return cleaned.isEmpty;
  }
}
