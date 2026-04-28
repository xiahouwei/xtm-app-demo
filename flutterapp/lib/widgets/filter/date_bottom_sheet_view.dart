import 'package:flutter/material.dart';
import 'package:flutter_proj/enum/date_filter_enum.dart';
import 'package:flutter_proj/models/widget/date_filter_model.dart';
import 'package:flutter_proj/theme/theme_notifier.dart';
import 'package:flutter_proj/utils/time_utils.dart';
import 'package:flutter_proj/widgets/filter/date_filter_widget.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import 'package:provider/provider.dart';

/// 底部弹窗选择时间 view
class DateBottomSheetView extends StatefulWidget {
  final String title;

  /// 时间筛选控件数据
  final DateFilterModel filterData;

  /// 默认时间范围
  final DateFilterEnum defaultDateRange;

  /// 可选时间最大范围
  final DateFilterEnum selectDateRange;

  const DateBottomSheetView({
    Key key,
    this.title,
    @required this.filterData,
    @required this.defaultDateRange,
    @required this.selectDateRange,
  }) : super(key: key);

  @override
  State<DateBottomSheetView> createState() => _BillFilterState();
}

class _BillFilterState extends State<DateBottomSheetView> {
  ThemeNotifier _theme;

  final GlobalKey<DateFilterWidgetState> _timeKey = GlobalKey<DateFilterWidgetState>();
  DateFilterModel _filterData;

  @override
  void initState() {
    super.initState();
    _filterData = widget.filterData;
  }

  @override
  Widget build(BuildContext context) {
    _theme = Provider.of<ThemeNotifier>(context, listen: true);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      padding: EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 40),
              Expanded(
                child: Text(
                  widget.title ?? '选择时间',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.close, size: 20),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  })
            ],
          ),
          SizedBox(height: 5),
          Expanded(
            child: DateFilterWidget(
              key: _timeKey,
              initModel: _filterData,
              onDateSelected: (date) {
                _filterData = date;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: XtmTextButton(
                    text: '重置',
                    textColor: _theme.titleTextColor,
                    backgroundColor: _theme.unSelectBgColor,
                    borderSideColor: _theme.unSelectBgColor,
                    onPressed: () {
                      _resetFilterData();
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: XtmTextButton(
                    text: '确定',
                    onPressed: () {
                      _verifyDate();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _verifyDate() {
    if (_filterData.beginDate == null || _filterData.endDate == null) {
      XtmToast.warn('请选择自定义日期范围');
      return;
    }
    int _maxDays = _getRangeDays(widget.selectDateRange);
    bool isOverDate = TimeUtils.isEndGreaterThanStartDays(
      startDate: _filterData.beginDate,
      endDate: _filterData.endDate,
      days: _maxDays,
    );
    if (isOverDate) {
      XtmToast.warn('所选时间间隔不能超过$_maxDays天');
      return;
    }
    Navigator.of(context).pop(_filterData);
  }

  void _resetFilterData() {
    _filterData.selectedDate = widget.defaultDateRange;
    int beforeDays = _getRangeDays(widget.defaultDateRange);
    _filterData.beginDate = TimeUtils.getTimeBefore(
      beforeDays: beforeDays,
      format: DateFormatType.yyyyMMdd,
    );
    _filterData.endDate = TimeUtils.getTimeNow(format: DateFormatType.yyyyMMdd);
    _timeKey.currentState.resetDate(_filterData);
    setState(() {});
  }

  int _getRangeDays(DateFilterEnum dateRange) {
    int _rangeDays = 7;
    if (dateRange == DateFilterEnum.SEVEN_DAYS) {
      _rangeDays = 7;
    } else if (dateRange == DateFilterEnum.FIFTEEN_DAYS) {
      _rangeDays = 15;
    } else if (dateRange == DateFilterEnum.ONE_MONTH) {
      _rangeDays = 31;
    }
    return _rangeDays;
  }
}
