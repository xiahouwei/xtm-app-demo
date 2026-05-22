import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

import '../../../utils/xtm_time_utils.dart';

class XtmDateFilterWidget extends StatefulWidget {
  final ValueChanged<XtmDateRangePickerModel> onDateSelected;
  final XtmDateRangePickerModel initModel;

  const XtmDateFilterWidget({
    Key key,
    this.initModel,
    this.onDateSelected,
  }) : super(key: key);

  @override
  State<XtmDateFilterWidget> createState() => XtmDateFilterWidgetState();
}

class XtmDateFilterWidgetState extends State<XtmDateFilterWidget> {
  int _selectedDate;
  String _beginDate;
  String _endDate;
  XtmDateRangePickerModel _filterModel;

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
                  backgroundColor: xtmDesignConfig.unSelectBgColor,
                  textColor: _beginDate == null
                      ? xtmDesignConfig.titleTextColor
                      : xtmDesignConfig.mainColor,
                  borderSideColor: _beginDate == null
                      ? xtmDesignConfig.unSelectBgColor
                      : xtmDesignConfig.mainColor,
                  onPressed: _selectedDate == XtmDateRangePickerLimitConstants.CUSTOM
                      ? () => selectStartDate()
                      : null,
                ),
              ),
              Text(' -- '),
              Expanded(
                child: XtmTextButton(
                  width: double.infinity,
                  text: _endDate ?? '结束日期',
                  backgroundColor: xtmDesignConfig.unSelectBgColor,
                  textColor:
                      _endDate == null ? xtmDesignConfig.titleTextColor : xtmDesignConfig.mainColor,
                  borderSideColor: _endDate == null
                      ? xtmDesignConfig.unSelectBgColor
                      : xtmDesignConfig.mainColor,
                  onPressed: _selectedDate == XtmDateRangePickerLimitConstants.CUSTOM
                      ? () => selectEndDate()
                      : null,
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
        backgroundColor: _selectedDate == XtmDateRangePickerLimitConstants.SEVEN_DAYS
            ? xtmDesignConfig.mainColor
            : xtmDesignConfig.unSelectBgColor,
        borderSideColor: _selectedDate == XtmDateRangePickerLimitConstants.SEVEN_DAYS
            ? xtmDesignConfig.mainColor
            : xtmDesignConfig.unSelectBgColor,
        textColor: _selectedDate == XtmDateRangePickerLimitConstants.SEVEN_DAYS
            ? Colors.white
            : xtmDesignConfig.mainTextColor,
        onPressed: () {
          setState(() {
            _selectedDate = XtmDateRangePickerLimitConstants.SEVEN_DAYS;
            _setDate(beforeDays: 7);
          });
        },
      ),
      XtmTextButton(
        text: '近15天',
        backgroundColor: _selectedDate == XtmDateRangePickerLimitConstants.FIFTEEN_DAYS
            ? xtmDesignConfig.mainColor
            : xtmDesignConfig.unSelectBgColor,
        borderSideColor: _selectedDate == XtmDateRangePickerLimitConstants.FIFTEEN_DAYS
            ? xtmDesignConfig.mainColor
            : xtmDesignConfig.unSelectBgColor,
        textColor: _selectedDate == XtmDateRangePickerLimitConstants.FIFTEEN_DAYS
            ? Colors.white
            : xtmDesignConfig.mainTextColor,
        onPressed: () {
          setState(() {
            _selectedDate = XtmDateRangePickerLimitConstants.FIFTEEN_DAYS;
            _setDate(beforeDays: 15);
          });
        },
      ),
      XtmTextButton(
        text: '近1个月',
        backgroundColor: _selectedDate == XtmDateRangePickerLimitConstants.ONE_MONTH
            ? xtmDesignConfig.mainColor
            : xtmDesignConfig.unSelectBgColor,
        borderSideColor: _selectedDate == XtmDateRangePickerLimitConstants.ONE_MONTH
            ? xtmDesignConfig.mainColor
            : xtmDesignConfig.unSelectBgColor,
        textColor: _selectedDate == XtmDateRangePickerLimitConstants.ONE_MONTH
            ? Colors.white
            : xtmDesignConfig.mainTextColor,
        onPressed: () {
          setState(() {
            _selectedDate = XtmDateRangePickerLimitConstants.ONE_MONTH;
            _setDate(beforeDays: 31);
          });
        },
      ),
      XtmTextButton(
        text: '自定义',
        backgroundColor: _selectedDate == XtmDateRangePickerLimitConstants.CUSTOM
            ? xtmDesignConfig.mainColor
            : xtmDesignConfig.unSelectBgColor,
        borderSideColor: _selectedDate == XtmDateRangePickerLimitConstants.CUSTOM
            ? xtmDesignConfig.mainColor
            : xtmDesignConfig.unSelectBgColor,
        textColor: _selectedDate == XtmDateRangePickerLimitConstants.CUSTOM
            ? Colors.white
            : xtmDesignConfig.mainTextColor,
        onPressed: () {
          setState(() {
            _selectedDate = XtmDateRangePickerLimitConstants.CUSTOM;
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
        String startDate = XtmTimeUtils.formatDateTimeToString(date, format: _filterModel.format);
        if (_endDate != null) {
          if (XtmTimeUtils.isBefore(startDate, _endDate)) {
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
        String endDate = XtmTimeUtils.formatDateTimeToString(date, format: _filterModel.format);
        if (_beginDate != null) {
          if (XtmTimeUtils.isBefore(_beginDate, endDate)) {
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
      _endDate = XtmTimeUtils.formatDateTimeStringToString(
        XtmTimeUtils.completeEndDateTime(),
        format: _filterModel.format,
      );
      _beginDate = XtmTimeUtils.formatDateTimeStringToString(
          XtmTimeUtils.getBeginDateTimeByEndTime(
            date: _endDate,
            durationDay: beforeDays,
          ),
          format: _filterModel.format);
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

  void resetDate(XtmDateRangePickerModel model) {
    setState(() {
      _filterModel = model;
      _initDateRange();
    });
  }
}
