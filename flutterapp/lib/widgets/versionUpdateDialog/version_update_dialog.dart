import 'package:flutter/material.dart';
import 'package:flutter_proj/widgets/versionUpdateDialog/version_update_widget.dart';
import 'package:flutter_proj/store/global_store.dart';

void xtmShowVersionUpdateDialog(BuildContext context,
    {bool barrierDismissible = false,
    Color barrierColor = Colors.black54,
    String latestVersionDesc,
    String currentVersionDesc,
    bool hiddenBoxButton,
    GestureTapCallback onLeftTap,
    GestureTapCallback onRightTap}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    useSafeArea: true,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: xtmGlobalStore.system.fontScale),
        child: Builder(
          builder: (BuildContext context) {
            return VersionUpdateWidget(
              latestVersionDesc: latestVersionDesc,
              currentVersionDesc: currentVersionDesc,
              hiddenBoxButton: hiddenBoxButton,
              onLeftTap: onLeftTap,
              onRightTap: onRightTap,
              onWillPop: () async {
                return false;
              },
            );
          },
        ),
      );
    },
  );
}
