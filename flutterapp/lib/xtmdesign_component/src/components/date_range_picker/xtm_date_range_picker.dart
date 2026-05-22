import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

import '../../constants/xtm_date_constants.dart';
import '../../utils/xtm_time_utils.dart';
import 'widget/xtm_date_bottom_sheet_view.dart';

/// 日期范围选择器的数据模型。
///
/// [XtmDateRangePickerModel] 用于封装日期范围的起始时间、结束时间以及相关格式。
/// 如果在初始化时未提供具体的开始和结束时间，它会根据 [selectedDate]（如7天前）
/// 自动计算并生成默认的时间范围。
class XtmDateRangePickerModel {
  /// 选中的快捷日期范围标识
  int selectedDate;

  /// 开始日期
  String beginDate;

  /// 结束日期
  String endDate;

  /// 日期格式化字符串
  String format;

  XtmDateRangePickerModel({
    this.selectedDate,
    String beginDate,
    String endDate,
    this.format = XtmDateFormatType.yyyyMMdd,
  }) {
    this.endDate = endDate ??
        XtmTimeUtils.formatDateTimeStringToString(XtmTimeUtils.completeEndDateTime(),
            format: format);
    this.beginDate = beginDate ??
        XtmTimeUtils.formatDateTimeStringToString(
            XtmTimeUtils.getBeginDateTimeByEndTime(
                date: this.endDate,
                durationDay: selectedDate ?? XtmDateRangePickerLimitConstants.SEVEN_DAYS),
            format: format);
  }
}

/// 显示日期范围选择器
class XtmDateRangePicker {
  /// 显示日期范围选择底部弹窗。
  ///
  /// [context] 为构建上下文。
  /// [filterDate] 为初始的日期范围模型，用于回显或设置默认值。
  /// [defaultDateRange] 默认的快捷日期范围标识。
  /// [selectDateRange] 当前选中的快捷日期范围标识。
  static Future<XtmDateRangePickerModel> showDateRangePicker(
    BuildContext context, {
    XtmDateRangePickerModel filterDate,
    int defaultDateRange,
    int selectDateRange,
  }) async {
    FocusScope.of(context).unfocus();
    XtmDateRangePickerModel result = await showModalBottomSheet<XtmDateRangePickerModel>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.6),
      builder: (ctx) {
        return XtmDateBottomSheetView(
          filterData: filterDate,
          defaultDateRange: defaultDateRange,
          selectDateRange: selectDateRange,
        );
      },
    );
    if (result == null) {
      return Future.error('取消');
    }
    return Future.value(result);
  }
}
