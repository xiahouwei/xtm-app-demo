import 'package:intl/intl.dart';

class DateFormatType {
  static const String yyyyMMddHHmmss = 'yyyy-MM-dd HH:mm:ss';
  static const String yyyyMMddHHmm = 'yyyy-MM-dd HH:mm';
  static const String yyyyMMdd = 'yyyy-MM-dd';
  static const String HHmmss = 'HH:mm:ss';
  static const String HHmm = 'HH:mm';
}

class TimeUtils {
  ///M:month,D:day,H:hour,M:minute
  static String formatterTimeToMDHM(String originTime) {
    if (originTime != null && originTime.length > 0) {
      DateTime time = DateTime.parse(originTime);
      String year = '${time.year}';
      String month = '${time.month}';
      String day = '${time.day}';
      String hour = '${time.hour}';
      String minute = '${time.minute}';
      if (time.hour < 10) {
        hour = '0' + hour;
      }
      if (time.minute < 10) {
        minute = '0' + minute;
      }
      DateTime currentTime = DateTime.now();
      String currentYear = currentTime.year.toString();
      String currentMonth = currentTime.month.toString();
      String currentDay = currentTime.day.toString();
      if (currentYear == year && currentMonth == month && currentDay == day) {
        String totalStr = '今天 $hour:$minute';
        return totalStr;
      } else {
        if (time.day < 10) {
          day = '0' + day;
        }
        String totalStr = '$month-$day $hour:$minute';
        return totalStr;
      }
    }
    return '';
  }

  ///获取当前时间
  static String getTimeNow({String format = DateFormatType.yyyyMMddHHmmss}) {
    DateTime now = DateTime.now();
    return DateFormat(format).format(now);
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

  /// 获取n天之前
  static String getTimeBefore({
    String date,
    int beforeDays = 0,
    String format = DateFormatType.yyyyMMddHHmmss,
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
    return TimeUtils.formatDateTimeToString(currentTime, format: format);
  }

  /// 时间格式转换-日期类型转字符串
  static String formatDateTimeToString(
    DateTime dateTime, {
    String format = DateFormatType.yyyyMMddHHmmss,
  }) {
    if (dateTime == null) return '';
    String formattedDate = DateFormat(format).format(dateTime);
    return formattedDate;
  }

  /// 时间格式转换-字符串转字符串
  static String formatDateTimeStringToString(
    String dateTime, {
    String format = DateFormatType.yyyyMMddHHmmss,
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
