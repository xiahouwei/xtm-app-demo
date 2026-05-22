import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

import '../../../utils/xtm_time_utils.dart';
import './xtm_date_filter_widget.dart';

/// 底部弹窗选择时间 view
class XtmDateBottomSheetView extends StatefulWidget {
  final String title;

  /// 时间筛选控件数据
  final XtmDateRangePickerModel filterData;

  /// 默认时间范围
  final int defaultDateRange;

  /// 可选时间最大范围
  final int selectDateRange;

  const XtmDateBottomSheetView({
    Key key,
    this.title,
    @required this.filterData,
    @required this.defaultDateRange,
    @required this.selectDateRange,
  }) : super(key: key);

  @override
  State<XtmDateBottomSheetView> createState() => XtmDateBottomSheetViewState();
}

class XtmDateBottomSheetViewState extends State<XtmDateBottomSheetView> {
  final GlobalKey<XtmDateFilterWidgetState> _timeKey = GlobalKey<XtmDateFilterWidgetState>();
  XtmDateRangePickerModel _filterData;

  @override
  void initState() {
    super.initState();
    _filterData = widget.filterData;
  }

  @override
  Widget build(BuildContext context) {
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
            child: XtmDateFilterWidget(
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
                    textColor: xtmDesignConfig.titleTextColor,
                    backgroundColor: xtmDesignConfig.unSelectBgColor,
                    borderSideColor: xtmDesignConfig.unSelectBgColor,
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
    int _maxDays = widget.selectDateRange ?? 0;
    bool isOverDate = XtmTimeUtils.isEndGreaterThanStartDays(
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
    int beforeDays = widget.defaultDateRange ?? 0;
    _filterData.beginDate = XtmTimeUtils.getTimeBefore(
      beforeDays: beforeDays,
      format: _filterData.format,
    );
    _filterData.endDate = XtmTimeUtils.getTimeNow(format: _filterData.format);
    _timeKey.currentState.resetDate(_filterData);
    setState(() {});
  }
}
