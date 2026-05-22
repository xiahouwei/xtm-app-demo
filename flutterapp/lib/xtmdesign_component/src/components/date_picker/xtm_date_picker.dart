import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import '../../constants/xtm_date_constants.dart';
import '../../utils/xtm_time_utils.dart';
import '../../utils/xtm_async_utils.dart';

/// 日期与时间选择器工具类。
///
/// [XtmDatePicker] 封装了底层的日期时间选择组件，
/// 结合 [XtmAsyncUtils] 以 Promise 的形式返回结果，
/// 支持自定义时间格式、最大时间限制等，方便业务层通过 `await` 获取用户选择的时间字符串。
class XtmDatePicker {
  /// 显示日期选择器。
  ///
  /// [context] 为构建上下文。
  /// [currentTime] 为默认选中的时间（字符串格式），不传则默认为当前时间。
  /// [maxTime] 为可选择的最大时间限制。
  /// [valueFormat] 为返回的时间字符串格式，默认为 [XtmDateFormatType.yyyyMMdd]。
  ///
  /// 返回格式化后的日期字符串。
  static Future<String> showDatePicker(
    BuildContext context, {
    String currentTime,
    DateTime maxTime,
    String valueFormat = XtmDateFormatType.yyyyMMdd,
  }) {
    return XtmAsyncUtils.PromiseFunction<String>((promise) {
      DatePicker.showDatePicker(
        context,
        locale: LocaleType.zh,
        maxTime: maxTime,
        currentTime: currentTime == null ? DateTime.now() : DateTime.parse(currentTime),
        onConfirm: (date) {
          promise.complete(XtmTimeUtils.formatDateTimeToString(date, format: valueFormat));
        },
      );
    });
  }

  /// 显示时间选择器。
  ///
  /// [context] 为构建上下文。
  /// [currentTime] 为默认选中的时间（如 "12:30:00"），不传则默认为当前时间。
  /// [showSecondsColumn] 是否显示秒数列，默认为 false。
  /// [valueFormat] 为返回的时间字符串格式，默认为 [XtmDateFormatType.HHmmss]。
  ///
  /// 返回格式化后的时间字符串。
  static Future<String> showTimePicker(
    BuildContext context, {
    String currentTime,
    bool showSecondsColumn = false,
    String valueFormat = XtmDateFormatType.HHmmss,
  }) {
    return XtmAsyncUtils.PromiseFunction<String>((promise) {
      DateTime _currentTime = DateTime.now();
      if (currentTime != null) {
        String time =
            '${XtmTimeUtils.formatDateTimeToString(DateTime.now(), format: XtmDateFormatType.yyyyMMdd)} ${currentTime}';
        _currentTime = DateTime.parse(time);
      }

      DatePicker.showTimePicker(
        context,
        locale: LocaleType.zh,
        showSecondsColumn: showSecondsColumn,
        currentTime: _currentTime,
        onConfirm: (date) {
          promise.complete(XtmTimeUtils.formatDateTimeToString(date, format: valueFormat));
        },
      );
    });
  }
}
