/// 时间区间选择器最大值常量
class XtmDateRangePickerLimitConstants {
  static const int SEVEN_DAYS = 7;
  static const int FIFTEEN_DAYS = 15;
  static const int ONE_MONTH = 31;
  static const int FORTY_DAYS = 40;
  static const int THREE_MONTHS = 93;
  static const int CUSTOM = null;

  static String getDatePickerRangeName(int limit) {
    if (limit == null) {
      return '自定义';
    }
    switch (limit) {
      case SEVEN_DAYS:
        return "近7天";
      case FIFTEEN_DAYS:
        return "近15天";
      case ONE_MONTH:
        return "近1个月";
      case FORTY_DAYS:
        return "近40天";
      case THREE_MONTHS:
        return "近3个月";
      default:
        return "近7天";
    }
  }
}
