import 'package:intl/intl.dart';

class NumberUtil {
  static String moneyFormat(String num) {
    if (num == null || num == 'null' || num == '') {
      return '0';
    } else {
      if (num.contains(',')) {
        return num;
      }

      String preStr = '';
      String subStr = '';
      if (num.contains('.')) {
        preStr = num.split('.')[0];
        subStr = num.split('.')[1] + '00';
        subStr = subStr.substring(0, 2);
      } else {
        preStr = num;
        subStr = '00';
      }
      var moneyStr;
      if (preStr.length < 6) {
        ///无后缀
        var numFormat = NumberFormat("#,###", "zh-CN");
        moneyStr = numFormat.format(double.parse(preStr)) + '.' + subStr;
      } else if ((6 <= preStr.length) && (preStr.length < 9)) {
        ///万
        preStr = (int.parse(preStr) / 10000).toString();
        var numFormat = NumberFormat("#,##0.00", "zh-CN");
        moneyStr = numFormat.format(double.parse(preStr));
        moneyStr = moneyStr + '万';
      } else {
        ///亿
        preStr = (int.parse(preStr) / 100000000).toString();
        var numFormat = NumberFormat("#,##0.00", "zh-CN");
        moneyStr = numFormat.format(double.parse(preStr));
        moneyStr = moneyStr + '亿';
      }
      return moneyStr.toString();
    }
  }

  static bool int2Bool(int num) {
    if (num == null) {
      return false;
    }
    return num != 0;
  }

  /*
  * @places 保留的位数
  * @weightValue 重量值，可以任何类型
  * */
  static String formatDecimalPlaces({int places, dynamic weightValue}) {
    if (weightValue == null) return "";
    try {
      double number;
      if (weightValue is String) {
        if (weightValue.isEmpty) return weightValue;
        number = double.parse(weightValue);
      } else if (weightValue is int) {
        number = weightValue.toDouble();
      } else if (weightValue is double) {
        number = weightValue;
      } else {
        return "";
      }
      if (places != null && places >= 0) {
        return number.toStringAsFixed(places);
      }
      return number.toString();
    } catch (e) {
      return "";
    }
  }

  static String currencyFormat({num amount, String symbol = '', int decimalDigits = 2}) {
    if (amount == null) return '--';
    final formatter =
        NumberFormat.currency(locale: 'zh_CN', symbol: symbol, decimalDigits: decimalDigits);
    return formatter.format(amount);
  }

  /*
  *  保留指定的小数位数，不进行四舍五入
  * */
  static String formatDouble(double value, int decimalPlaces) {
    if (value == null) return '';
    String strValue = value.toString();

    int decimalIndex = strValue.indexOf('.');

    if (decimalIndex == -1) {
      // 如果没有小数点，小数补零
      return strValue + '.' + '0' * decimalPlaces;
    }

    // 截取小数部分
    String integerPart = strValue.substring(0, decimalIndex);
    String decimalPart = strValue.substring(decimalIndex + 1);

    // 保留指定的小数位数，不进行四舍五入
    if (decimalPart.length > decimalPlaces) {
      decimalPart = decimalPart.substring(0, decimalPlaces);
    } else {
      decimalPart = decimalPart.padRight(decimalPlaces, '0');
    }

    return '$integerPart.$decimalPart';
  }
}
