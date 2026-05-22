import 'package:flutter/material.dart';

class AppListView extends ListView {
  AppListView.separated({
    Key key,
    int itemCount,
    bool shrinkWrap = false,
    ScrollPhysics physics = const AlwaysScrollableScrollPhysics(),
    Widget Function(BuildContext, int) itemBuilder,
    Widget Function(BuildContext, int) separatorBuilder,
  }) : super.separated(
          key: key,
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: itemCount,
          itemBuilder: itemBuilder,
          physics: physics,
          shrinkWrap: shrinkWrap,
          separatorBuilder: separatorBuilder ?? (_, __) => const SizedBox(height: 10),
        );
}
