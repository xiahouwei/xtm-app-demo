import 'package:flutter/cupertino.dart';

class AppListBlockRow extends StatelessWidget {
  final List<Widget> children;

  /// padding
  final EdgeInsetsGeometry padding;

  final MainAxisAlignment mainAxisAlignment;

  AppListBlockRow({
    this.children = const <Widget>[],
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: children,
        mainAxisAlignment: mainAxisAlignment,
      ),
    );
  }
}
