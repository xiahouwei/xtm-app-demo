import 'package:flutter_proj/store/global_store_base.dart';
import 'package:flutter_proj/store/local_storage.dart';
import 'package:flutter_proj/store/system/state.dart';

class FontScaleConstants {
  static double NORMAL = 1.0;
  static double BIG = 1.4;
}

class SystemStoreConstants {
  static const String KEY_FONT_SCALE = "fontScale";
  static const String KEY_RECEIVE_COUNT = "receiveCount";
}

class SystemGlobalStore extends GlobalStoreBase<SystemGlobalState> {
  SystemGlobalStore();

  @override
  SystemGlobalState state = SystemGlobalState();

  @override
  Future<void> init() async {
    state.fontScale = await LocalStorage.getDouble(
        SystemStoreConstants.KEY_FONT_SCALE, FontScaleConstants.NORMAL);
    state.receiveCount = 0;
  }

  double get fontScale => state.fontScale;

  void setFontScale(double value) {
    state.fontScale = value;
    LocalStorage.set(SystemStoreConstants.KEY_FONT_SCALE, value);
  }

  int get receiveCount => state.receiveCount;

  void setReceiveCount(int value) {
    state.receiveCount = value;
  }
}
