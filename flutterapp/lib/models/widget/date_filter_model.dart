import 'package:flutter_proj/enum/date_filter_enum.dart';

/// 时间范围 Model
class DateFilterModel {
  DateFilterEnum selectedDate;
  String beginDate;
  String endDate;

  DateFilterModel({
    this.selectedDate,
    this.beginDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'beginDate': beginDate,
      'endDate': endDate,
    };
  }
}
