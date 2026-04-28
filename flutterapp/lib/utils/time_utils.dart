import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DateFormatType {
  static const String yyyyMMddHHmmss = 'yyyy-MM-dd HH:mm:ss';
  static const String yyyyMMddHHmm = 'yyyy-MM-dd HH:mm';
  static const String yyyyMMdd = 'yyyy-MM-dd';
}

class TimeUtils {
  static Map weekdays = {
    1: '星期一',
    2: '星期二',
    3: '星期三',
    4: '星期四',
    5: '星期五',
    6: '星期六',
    7: '星期七',
  };

  ///M:month,D:day,H:hour,M:minute
  static String formatterTimeToMDHM(String originTime) {
    if (originTime != null && originTime.length > 0) {
      ///先转换到date类型
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

  /// 一天内显示 n分钟/ n小时前；七天内发布显示 周n + 时间（时分）；
  /// 发布时间距离现在七天以上且本年度发布则显示月日；非本年度发布显示年月日
  static String formatterDateTime(String originTime) {
    if (originTime != null && originTime.length > 0) {
      ///先转换到date类型
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
      if (currentTime.difference(time).inSeconds < 60) {
        String totalStr = '刚刚';
        return totalStr;
      } else if (currentTime.difference(time).inMinutes < 60) {
        int minutesBefore = currentTime.difference(time).inMinutes;
        String totalStr = '$minutesBefore分钟前';
        return totalStr;
      } else if (currentTime.difference(time).inHours < 24) {
        int hoursBefore = currentTime.difference(time).inHours;
        String totalStr = '$hoursBefore小时前';
        return totalStr;
      } else if (currentTime.difference(time).inDays <= 7) {
        String weekDayStr = weekdays[time.weekday];
        String totalStr = '$weekDayStr $hour:$minute';
        return totalStr;
      } else if (currentYear == year) {
        if (time.month < 10) {
          month = '0' + month;
        }
        if (time.day < 10) {
          day = '0' + day;
        }
        String totalStr = '$month月$day日';
        return totalStr;
      } else {
        if (time.month < 10) {
          month = '0' + month;
        }
        if (time.day < 10) {
          day = '0' + day;
        }
        String totalStr = '$year年$month月$day日';
        return totalStr;
      }
    }
    return '';
  }

  ///获取当前时间
  // static String getTimeNow({String format = DateFormatType.yyyyMMddHHmmss}) {
  //   ///先转换到date类型
  //   DateTime now = DateTime.now();
  //   String formattedDate = DateFormat(format).format(now);
  //   return formattedDate;
  // }
  static String getTimeNow({String format = DateFormatType.yyyyMMddHHmmss, bool endOfDay = false}) {
    DateTime now = DateTime.now();
    if (endOfDay) {
      now = DateTime(now.year, now.month, now.day, 23, 59, 59);
    }
    return DateFormat(format).format(now);
  }

  /// 获取当天 00:00:00
  static String getBeginOfDay({String date}) {
    return getDayFormatByDate(date: date, hour: 00, min: 00, sec: 00);
  }

  /// 获取当天 23:59:59
  static String getEndOfDay({String date}) {
    return getDayFormatByDate(date: date, hour: 23, min: 59, sec: 59);
  }

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
  static String getTimeBefore(
      {String date,
      int beforeDays = 0,
      String format = DateFormatType.yyyyMMddHHmmss,
      bool beginOfDay = false}) {
    DateTime nowTime = date == null ? DateTime.now() : DateFormat(format).parse(date);
    DateTime currentTime;
    if (beginOfDay) {
      currentTime = DateTime(
        nowTime.year,
        nowTime.month,
        nowTime.day - beforeDays,
        00,
        00,
        00,
      );
    } else {
      currentTime = DateTime(
        nowTime.year,
        nowTime.month,
        nowTime.day - beforeDays,
        nowTime.hour,
        nowTime.minute,
        nowTime.second,
      );
    }
    return TimeUtils.formatDateTimeToString(currentTime, format: format);
  }

  /// 获取n天(n = nextDay)之后的时间
  static String getNextDaysDate({
    String date,
    int nextDays,
    String format = DateFormatType.yyyyMMddHHmmss,
  }) {
    DateTime beginTime = date == null ? DateTime.now() : DateFormat(format).parse(date);
    DateTime endTime = new DateTime(
      beginTime.year,
      beginTime.month,
      beginTime.day + nextDays,
      beginTime.hour,
      beginTime.minute,
    );
    String formattedDate = DateFormat(format).format(endTime);
    return formattedDate;
  }

  /// 比较时间(比较time2是否早于time1)
  static bool isBefore(String time1, String time2) {
    DateTime date1 = DateTime.parse(time1);
    DateTime date2 = DateTime.parse(time2);
    return date2.isBefore(date1);
  }

  static bool time1BiggerOrSameThanTime2({
    @required String time1,
    @required String time2,
  }) {
    if (time1 == null || time1.isEmpty || time2 == null || time2.isEmpty) {
      return false;
    }
    DateTime time1Date = DateTime.parse(time1);
    DateTime time2Date = DateTime.parse(time2);
    Duration compare = time1Date.difference(time2Date);
    if (compare.inSeconds >= 0) {
      return true;
    } else {
      return false;
    }
  }

  /// 计算开始时间和结束时间差多少天
  static int getDateDifference(String beginTime, String endTime) {
    if (beginTime == null || beginTime.isEmpty || endTime == null || endTime.isEmpty) return 0;
    DateTime beginDateTime = DateTime.parse(beginTime);
    DateTime endDateTime = DateTime.parse(endTime);
    return endDateTime.difference(beginDateTime).inDays;
  }

  /// 结束时间是否大于开始时间 n 个月
  static bool isEndGreaterThanStartMonths({
    String startDate,
    String endDate,
    int months = 3,
  }) {
    if (startDate == null || endDate == null) return false;
    DateTime startDateTime = DateTime.parse(startDate);
    DateTime endDateTime = DateTime.parse(endDate);
    DateTime monthsLater = DateTime(
      startDateTime.year,
      startDateTime.month + months,
      startDateTime.day,
      startDateTime.hour,
      startDateTime.minute,
    );
    DateTime endDateWithoutSecond = DateTime(
      endDateTime.year,
      endDateTime.month,
      endDateTime.day,
      endDateTime.hour,
      endDateTime.minute,
    );
    return endDateWithoutSecond.isAfter(monthsLater);
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
    String format = DateFormatType.yyyyMMddHHmmss,
  }) {
    if (dateTime == null) return '';
    String formattedDate = DateFormat(format).format(dateTime);
    return formattedDate;
  }
}
