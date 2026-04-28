import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_proj/enum/date_filter_enum.dart';
import 'package:flutter_proj/models/widget/date_filter_model.dart';
import 'package:flutter_proj/theme/theme_notifier.dart';
import 'package:flutter_proj/utils/time_utils.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import 'package:provider/provider.dart';

class DateFilterWidget extends StatefulWidget {
  final ValueChanged<DateFilterModel> onDateSelected;
  final DateFilterModel initModel;

  const DateFilterWidget({
    Key key,
    this.initModel,
    this.onDateSelected,
  }) : super(key: key);

  @override
  State<DateFilterWidget> createState() => DateFilterWidgetState();
}

class DateFilterWidgetState extends State<DateFilterWidget> {
  ThemeNotifier _theme;
  DateFilterEnum _selectedDate;
  String _beginDate;
  String _endDate;
  DateFilterModel _filterModel;

  @override
  void initState() {
    super.initState();
    _filterModel = widget.initModel;
    _initDateRange();
  }

  void _initDateRange() {
    _selectedDate = _filterModel.selectedDate;
    _beginDate = _filterModel.beginDate;
    _endDate = _filterModel.endDate;
  }

  @override
  Widget build(BuildContext context) {
    _theme = Provider.of<ThemeNotifier>(context, listen: true);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('筛选时间'),
          SizedBox(height: 10),
          _buildTimeGrid(),
          SizedBox(height: 20),
          Text('自定义选择'),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: XtmTextButton(
                  width: double.infinity,
                  text: _beginDate ?? '开始日期',
                  backgroundColor: _theme.unSelectBgColor,
                  textColor: _beginDate == null ? _theme.titleTextColor : _theme.primaryColor,
                  borderSideColor:
                      _beginDate == null ? _theme.unSelectBgColor : _theme.primaryColor,
                  onPressed:
                      _selectedDate == DateFilterEnum.CUSTOM ? () => selectStartDate() : null,
                ),
              ),
              Text(' -- '),
              Expanded(
                child: XtmTextButton(
                  width: double.infinity,
                  text: _endDate ?? '结束日期',
                  backgroundColor: _theme.unSelectBgColor,
                  textColor: _endDate == null ? _theme.titleTextColor : _theme.primaryColor,
                  borderSideColor: _endDate == null ? _theme.unSelectBgColor : _theme.primaryColor,
                  onPressed: _selectedDate == DateFilterEnum.CUSTOM ? () => selectEndDate() : null,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTimeGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 15,
      children: _dateWidgets(),
    );
  }

  List<Widget> _dateWidgets() {
    return [
      XtmTextButton(
        text: '近7天',
        backgroundColor: _selectedDate == DateFilterEnum.SEVEN_DAYS
            ? _theme.primaryColor
            : _theme.unSelectBgColor,
        borderSideColor: _selectedDate == DateFilterEnum.SEVEN_DAYS
            ? _theme.primaryColor
            : _theme.unSelectBgColor,
        textColor: _selectedDate == DateFilterEnum.SEVEN_DAYS ? Colors.white : _theme.mainTextColor,
        onPressed: () {
          setState(() {
            _selectedDate = DateFilterEnum.SEVEN_DAYS;
            _setDate(beforeDays: 7);
          });
        },
      ),
      XtmTextButton(
        text: '近15天',
        backgroundColor: _selectedDate == DateFilterEnum.FIFTEEN_DAYS
            ? _theme.primaryColor
            : _theme.unSelectBgColor,
        borderSideColor: _selectedDate == DateFilterEnum.FIFTEEN_DAYS
            ? _theme.primaryColor
            : _theme.unSelectBgColor,
        textColor:
            _selectedDate == DateFilterEnum.FIFTEEN_DAYS ? Colors.white : _theme.mainTextColor,
        onPressed: () {
          setState(() {
            _selectedDate = DateFilterEnum.FIFTEEN_DAYS;
            _setDate(beforeDays: 15);
          });
        },
      ),
      XtmTextButton(
        text: '近1个月',
        backgroundColor: _selectedDate == DateFilterEnum.ONE_MONTH
            ? _theme.primaryColor
            : _theme.unSelectBgColor,
        borderSideColor: _selectedDate == DateFilterEnum.ONE_MONTH
            ? _theme.primaryColor
            : _theme.unSelectBgColor,
        textColor: _selectedDate == DateFilterEnum.ONE_MONTH ? Colors.white : _theme.mainTextColor,
        onPressed: () {
          setState(() {
            _selectedDate = DateFilterEnum.ONE_MONTH;
            _setDate(beforeDays: 31);
          });
        },
      ),
      XtmTextButton(
        text: '自定义',
        backgroundColor:
            _selectedDate == DateFilterEnum.CUSTOM ? _theme.primaryColor : _theme.unSelectBgColor,
        borderSideColor:
            _selectedDate == DateFilterEnum.CUSTOM ? _theme.primaryColor : _theme.unSelectBgColor,
        textColor: _selectedDate == DateFilterEnum.CUSTOM ? Colors.white : _theme.mainTextColor,
        onPressed: () {
          setState(() {
            _selectedDate = DateFilterEnum.CUSTOM;
            _setDate();
          });
        },
      ),
    ];
  }

  void selectStartDate() {
    DatePicker.showDatePicker(
      context,
      locale: LocaleType.zh,
      maxTime: DateTime.now(),
      currentTime: _beginDate == null ? DateTime.now() : DateTime.parse(_beginDate),
      onConfirm: (date) {
        String startDate = TimeUtils.formatDateTimeToString(date, format: DateFormatType.yyyyMMdd);
        if (_endDate != null) {
          if (TimeUtils.isBefore(startDate, _endDate)) {
            XtmToast.warn('开始时间不能大于结束时间');
            return;
          }
        }
        setState(() {
          _beginDate = startDate;
        });
        if (widget.onDateSelected != null) {
          _filterModel.beginDate = _beginDate;
          widget.onDateSelected(_filterModel);
        }
      },
    );
  }

  void selectEndDate() {
    DatePicker.showDatePicker(
      context,
      locale: LocaleType.zh,
      maxTime: DateTime.now(),
      currentTime: _endDate == null ? DateTime.now() : DateTime.parse(_endDate),
      onConfirm: (date) {
        String endDate = TimeUtils.formatDateTimeToString(date, format: DateFormatType.yyyyMMdd);
        if (_beginDate != null) {
          if (TimeUtils.isBefore(_beginDate, endDate)) {
            XtmToast.warn('开始时间不能大于结束时间');
            return;
          }
        }
        setState(() {
          _endDate = endDate;
        });
        if (widget.onDateSelected != null) {
          _filterModel.endDate = _endDate;
          widget.onDateSelected(_filterModel);
        }
      },
    );
  }

  void _setDate({int beforeDays = 0}) {
    if (beforeDays > 0) {
      _beginDate = TimeUtils.getTimeBefore(
        beforeDays: beforeDays,
        format: DateFormatType.yyyyMMdd,
      );
      _endDate = TimeUtils.getTimeNow(format: DateFormatType.yyyyMMdd);
    } else {
      _beginDate = null;
      _endDate = null;
    }
    if (widget.onDateSelected != null) {
      _filterModel.beginDate = _beginDate;
      _filterModel.endDate = _endDate;
      _filterModel.selectedDate = _selectedDate;
      widget.onDateSelected(_filterModel);
    }
  }

  void resetDate(DateFilterModel model) {
    setState(() {
      _filterModel = model;
      _initDateRange();
    });
  }
}
