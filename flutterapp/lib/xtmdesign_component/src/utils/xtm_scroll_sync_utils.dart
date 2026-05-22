import 'package:flutter/material.dart';

class XtmScrollSyncUtils {
  XtmScrollSyncUtils() {}
  bool _isSyncing = false;
  void bindScrollSync(List<ScrollController> controllers) {
    for (final source in controllers) {
      source.addListener(() {
        if (_isSyncing) return;
        _isSyncing = true;
        for (final target in controllers) {
          if (source == target) continue;
          if (!target.hasClients) continue;
          if (target.offset != source.offset) {
            target.jumpTo(source.offset);
          }
        }
        _isSyncing = false;
      });
    }
  }
}
