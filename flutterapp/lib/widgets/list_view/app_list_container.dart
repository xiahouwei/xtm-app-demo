import 'package:flutter/cupertino.dart';

class AppListContainer extends StatelessWidget {
  final Widget topWidget;
  final Widget listWidget;
  final Color backgroundColor;

  AppListContainer({
    @required this.listWidget,
    this.topWidget,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Column(
      children: [
        if (topWidget != null) topWidget,
        Expanded(
          child: listWidget,
        ),
      ],
    );
    if (backgroundColor == null) {
      return child;
    }
    return ColoredBox(
      color: backgroundColor,
      child: child,
    );
  }
}
