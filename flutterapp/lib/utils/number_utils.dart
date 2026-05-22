import 'package:flutter_proj/store/global_store.dart';

class NumberUtil {
  /// 金额格式化  默认小数点后两位,  不够补 0
  /// [money] 金额
  /// [showMoneySymbol] 是否显示货币符号
  static String moneyFormat(num money, {bool showMoneySymbol = false}) {
    String resultMoney = 'null';
    if (money == null) {
      return resultMoney;
    }
    String formattedMoney = money.toStringAsFixed(xtmGlobalStore.system.moneyDecimal);
    if (showMoneySymbol) {
      return '¥ $formattedMoney';
    }
    return formattedMoney;
  }
}
