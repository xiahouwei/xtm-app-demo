import 'package:flutter/cupertino.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

class AppListBlock extends StatelessWidget {
  final Widget child;

  AppListBlock({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: xtmDesignConfig.cardBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: child,
    );
  }
}
