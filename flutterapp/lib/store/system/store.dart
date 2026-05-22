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
  static const String KEY_OFTEN_MENUS = "oftenMenus";
  static const String KEY_MONEY_DECIMAL = "moneyDecimal";
}

class SystemGlobalStore extends GlobalStoreBase<SystemGlobalState> {
  SystemGlobalStore();

  @override
  SystemGlobalState state = SystemGlobalState();

  @override
  Future<void> init() async {
    state.fontScale = await LocalStorage.getDouble(
      SystemStoreConstants.KEY_FONT_SCALE,
      FontScaleConstants.NORMAL,
    );
    state.receiveCount = 0;
    state.lastChatMessageDatetime = '';
    state.moneyDecimal = await LocalStorage.getInt(SystemStoreConstants.KEY_MONEY_DECIMAL, 2);
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

  String get lastChatMessageDatetime => state.lastChatMessageDatetime;

  void setLastChatMessageDatetime(String value) {
    state.lastChatMessageDatetime = value;
  }

  int get moneyDecimal => state.moneyDecimal;

  void setMoneyDecimal(int value) {
    state.moneyDecimal = value;
    LocalStorage.set(SystemStoreConstants.KEY_MONEY_DECIMAL, value);
  }
}
