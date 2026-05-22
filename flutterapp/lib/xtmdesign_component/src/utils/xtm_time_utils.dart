import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../constants/xtm_date_constants.dart';

class XtmTimeUtils {
  ///获取当前时间
  static String getTimeNow({String format = XtmDateFormatType.yyyyMMddHHmmss}) {
    DateTime now = DateTime.now();
    return DateFormat(format).format(now);
  }

  /// 比较时间(比较time2是否早于time1)
  static bool isBefore(String time1, String time2) {
    DateTime date1 = DateTime.parse(time1);
    DateTime date2 = DateTime.parse(time2);
    return date2.isBefore(date1);
  }

  /// 获取n天之前
  static String getTimeBefore({
    String date,
    int beforeDays = 0,
    String format = XtmDateFormatType.yyyyMMddHHmmss,
  }) {
    DateTime nowTime = date == null ? DateTime.now() : DateFormat(format).parse(date);
    DateTime currentTime;
    currentTime = DateTime(
      nowTime.year,
      nowTime.month,
      nowTime.day - beforeDays,
      nowTime.hour,
      nowTime.minute,
      nowTime.second,
    );
    return formatDateTimeToString(currentTime, format: format);
  }

  /// 结束时间是否大于开始时间几天
  static bool isEndGreaterThanStartDays({
    @required String startDate,
    @required String endDate,
    int days = 7,
  }) {
    if (startDate == null || endDate == null || startDate.isEmpty || endDate.isEmpty) {
      return false;
    }
    DateTime startDateTime = DateTime.parse(startDate);
    DateTime endDateTime = DateTime.parse(endDate);
    DateTime limitDate = startDateTime.add(Duration(days: days));
    return endDateTime.isAfter(limitDate);
  }

  /// 时间格式转换
  static String formatDateTimeToString(
    DateTime dateTime, {
    String format = XtmDateFormatType.yyyyMMddHHmmss,
  }) {
    if (dateTime == null) return '';
    String formattedDate = DateFormat(format).format(dateTime);
    return formattedDate;
  }

  /// 时间格式转换-字符串转字符串
  static String formatDateTimeStringToString(
    String dateTime, {
    String format = XtmDateFormatType.yyyyMMddHHmmss,
  }) {
    if (dateTime == null || dateTime.isEmpty) {
      return '';
    }
    try {
      return DateFormat(format).format(DateTime.parse(dateTime));
    } catch (e) {
      return '';
    }
  }

  /// 自定义补全时期时分秒
  static String getDayFormatByDate({String date, int hour, int min, int sec}) {
    DateTime now;
    if (date == null || date.isEmpty) {
      now = DateTime.now();
    } else {
      final formats = [
        'yyyy-MM-dd HH:mm:ss',
        'yyyy-MM-dd',
        'yyyy/MM/dd HH:mm:ss',
        'yyyy/MM/dd',
        'yyyyMMdd',
      ];
      bool parsed = false;
      for (var format in formats) {
        try {
          now = DateFormat(format).parse(date);
          parsed = true;
          break;
        } catch (e) {
          continue;
        }
      }
      if (!parsed) {
        now = DateTime.now();
      }
    }
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(
      DateTime(now.year, now.month, now.day, hour, min, sec),
    );
  }

  /// 补全开始时间的时分秒
  static String completeStartDateTime({String date}) {
    return getDayFormatByDate(date: date, hour: 00, min: 00, sec: 00);
  }

  /// 补全结束时间的时分秒
  static String completeEndDateTime({String date}) {
    return getDayFormatByDate(date: date, hour: 23, min: 59, sec: 59);
  }

  /// 根据结束时间获取开始时间
  static String getBeginDateTimeByEndTime({String date, int durationDay}) {
    int _durationDay = durationDay > 0 ? durationDay - 1 : 0;
    DateTime dateTime = DateTime.parse(date);
    DateTime target = dateTime.subtract(Duration(days: _durationDay));
    DateTime startTime = DateTime(target.year, target.month, target.day);
    return completeStartDateTime(date: formatDateTimeToString(startTime));
  }
}
