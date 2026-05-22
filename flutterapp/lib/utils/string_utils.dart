import 'package:flutter_proj/xtmdesign_component/src/components/toast/xtm_toast.dart';

class StringUtils {
  // 纯数字
  // ignore: non_constant_identifier_names
  static final String DIGIT_REGEX = "[0-9]";

  // 含有数字
  // ignore: non_constant_identifier_names
  static final String CONTAIN_DIGIT_REGEX = ".*[0-9].*";

  // 纯字母
  // ignore: non_constant_identifier_names
  static final String LETTER_REGEX = "[a-zA-Z]+";

  // 包含字母
  // ignore: non_constant_identifier_names
  static final String SMALL_CONTAIN_LETTER_REGEX = ".*[a-z].*";

  // 包含字母
  // ignore: non_constant_identifier_names
  static final String BIG_CONTAIN_LETTER_REGEX = ".*[A-Z].*";

  // 包含字母
  // ignore: non_constant_identifier_names
  static final String CONTAIN_LETTER_REGEX = ".*[a-zA-Z].*";

  // 含中文
  // ignore: non_constant_identifier_names
  static final String CHINESE_REGEX = "[\u4e00-\u9fa5]";

  // 仅仅包含字母和数字
  // ignore: non_constant_identifier_names
  static final String LETTER_DIGIT_REGEX = "^[a-z0-9A-Z]+\$";

  // ignore: non_constant_identifier_names
  static final String CHINESE_LETTER_REGEX = "([\u4e00-\u9fa5]+|[a-zA-Z]+)";

  // ignore: non_constant_identifier_names
  static final String CHINESE_LETTER_DIGIT_REGEX = "^[a-z0-9A-Z\u4e00-\u9fa5]+\$";

  static bool isPassword(String password) {
    // 检查长度
    if (password.length < 8 || password.length > 18) {
      XtmToast.warn('密码长度限制8-18位');
      return false;
    }

    // 检查是否为纯数字
    if (RegExp(r'^\d+$').hasMatch(password)) {
      XtmToast.warn('密码不可为纯数字');
      return false;
    }

    // 检查是否为纯字母
    if (RegExp(r'^[A-Za-z]+$').hasMatch(password)) {
      XtmToast.warn('密码不可为纯字母');
      return false;
    }
    // 检查是否有汉字
    if (RegExp(r'[\u4e00-\u9fa5]').hasMatch(password)) {
      XtmToast.warn('密码不可有汉字');
      return false;
    }

    return true;
  }

  static bool isStrongPassword(String password, {int minLength = 8}) {
    if (password == null || password.length < minLength) return false;

    bool hasDigit = RegExp(r'[0-9]').hasMatch(password);
    bool hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    bool hasUppercase = RegExp(r'[A-Z]').hasMatch(password);

    return hasDigit && hasLowercase && hasUppercase;
  }

  ///是否为纯数字
  static bool isNumberOnly(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  /// 是否为中文
  static bool isChinese(String input) {
    if (input == null || input.isEmpty) return false;
    return new RegExp(CHINESE_REGEX).hasMatch(input);
  }

  ///大陆手机号码11位数
  static bool isPhoneNum(String str) {
    if (str.length == 11) {
      return true;
    }
    return false;
  }

  /// 邮箱判断
  static bool isEmail(String input) {
    String regexEmail =
        "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}\$";
    if (input == null || input.isEmpty) return false;
    return new RegExp(regexEmail).hasMatch(input);
  }

  ///验证URL
  static bool isUrl(String value) {
    if (value == null || value.isEmpty) return false;
    return RegExp(r"^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+").hasMatch(value);
  }

  ///验证https/http
  static bool isHTTPUrl(String value) {
    if (value == null || value.isEmpty) return false;
    return RegExp(r"^((https|http)?:\/\/)[^\s]+").hasMatch(value);
  }

  /// 校验身份证合法性
  static bool verifyCardId(String cardId) {
    const Map city = {
      11: "北京",
      12: "天津",
      13: "河北",
      14: "山西",
      15: "内蒙古",
      21: "辽宁",
      22: "吉林",
      23: "黑龙江 ",
      31: "上海",
      32: "江苏",
      33: "浙江",
      34: "安徽",
      35: "福建",
      36: "江西",
      37: "山东",
      41: "河南",
      42: "湖北 ",
      43: "湖南",
      44: "广东",
      45: "广西",
      46: "海南",
      50: "重庆",
      51: "四川",
      52: "贵州",
      53: "云南",
      54: "西藏 ",
      61: "陕西",
      62: "甘肃",
      63: "青海",
      64: "宁夏",
      65: "新疆",
      71: "台湾",
      81: "香港",
      82: "澳门",
      91: "国外 "
    };
    String tip = '';
    bool pass = true;

    RegExp cardReg =
        RegExp(r'^\d{6}(18|19|20)?\d{2}(0[1-9]|1[012])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$');
    if (cardId == null || cardId.isEmpty || !cardReg.hasMatch(cardId)) {
      tip = '身份证号格式错误';
      print(tip);
      pass = false;
      return pass;
    }
    if (city[int.parse(cardId.substring(0, 2))] == null) {
      tip = '地址编码错误';
      print(tip);
      pass = false;
      return pass;
    }
    // 18位身份证需要验证最后一位校验位，15位不检测了，现在也没15位的了
    if (cardId.length == 18) {
      List numList = cardId.split('');
      //∑(ai×Wi)(mod 11)
      //加权因子
      List factor = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
      //校验位
      List parity = [1, 0, 'X', 9, 8, 7, 6, 5, 4, 3, 2];
      int sum = 0;
      int ai = 0;
      int wi = 0;
      for (var i = 0; i < 17; i++) {
        ai = int.parse(numList[i]);
        wi = factor[i];
        sum += ai * wi;
      }
      // var last = parity[sum % 11];
      if (parity[sum % 11].toString() != numList[17]) {
        tip = "校验位错误";
        print(tip);
        pass = false;
      }
    } else {
      tip = '身份证号不是18位';
      print(tip);
      pass = false;
    }
    return pass;
  }

  ///只包含字母或数字
  static bool numberAndLetterOnly(String str) {
    return RegExp("^[A-Za-z0-9]+\$").hasMatch(str);
  }

  /// 空串 或  null 格式化
  static String emptyFormat(String value) {
    if (value == null || value.isEmpty || value.contains('null')) {
      return '-';
    }
    return value;
  }

  ///  判断是否是null或者空字符串
  static bool isEmptyText(String value) {
    return value == null || value.isEmpty || value.trim().isEmpty || value.contains('null');
  }
}
