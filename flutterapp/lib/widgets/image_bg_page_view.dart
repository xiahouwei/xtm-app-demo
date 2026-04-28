import 'package:flutter/material.dart';
import 'package:flutter_proj/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

class ImageBgPageView extends StatelessWidget {
  final Positioned imagePos;
  final Widget child;

  ImageBgPageView({
    this.imagePos,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context, listen: true);
    return Container(
      decoration: BoxDecoration(
        gradient: theme.pageBgColor,
      ),
      child: Stack(
        children: [
          imagePos ?? Container(),
          SafeArea(child: child),
        ],
      ),
    );
  }
}
