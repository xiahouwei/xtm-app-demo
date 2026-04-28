/// 时间筛选控件 枚举
enum DateFilterEnum {
  SEVEN_DAYS,
  FIFTEEN_DAYS,
  ONE_MONTH,
  CUSTOM,
}

class DateFilterFormat {
  static String getDateFilterName(DateFilterEnum dateFilter) {
    switch (dateFilter) {
      case DateFilterEnum.SEVEN_DAYS:
        return "近7天";
      case DateFilterEnum.FIFTEEN_DAYS:
        return "近15天";
      case DateFilterEnum.ONE_MONTH:
        return "近1个月";
      case DateFilterEnum.CUSTOM:
        return "自定义";
      default:
        return "近7天";
    }
  }
}
