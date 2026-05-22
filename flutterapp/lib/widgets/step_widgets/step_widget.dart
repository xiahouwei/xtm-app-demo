import 'package:flutter/material.dart';
import 'package:flutter_proj/models/widget/step_info_model.dart';
import 'package:flutter_proj/theme/theme_notifier.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import 'package:provider/provider.dart';

import 'step_bottom_sheet.dart';

/// 步进器组件
class StepWidget extends StatefulWidget {
  final String title;
  final List<StepInfoModel> stepList;
  final ValueChanged<int> onPreviousClick;
  final Future Function(int index) onNextClick;
  final Future Function(int index) onSelect;
  final Function onSubmit;
  final String lastButtonText;

  StepWidget({
    Key key,
    this.title = '注册步骤',
    @required this.stepList,
    @required this.onPreviousClick,
    @required this.onNextClick,
    @required this.onSelect,
    this.onSubmit,
    this.lastButtonText = '提交',
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StepWidgetState();
}

class _StepWidgetState extends State<StepWidget> {
  ThemeNotifier _theme;
  int _currentIndex = 0;
  int _totalStep;

  @override
  void initState() {
    _totalStep = widget.stepList.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Provider.of<ThemeNotifier>(context, listen: true);
    return Row(
      children: [
        SizedBox(width: 10.0),
        XtmTextButton(
          text: '上一步',
          width: 80,
          onPressed: () => onPreviousClick(),
          disabled: _currentIndex == 0,
        ),
        SizedBox(width: 8.0),
        Expanded(child: _buildStepShow()),
        SizedBox(width: 8.0),
        XtmTextButton(
          text: _currentIndex == _totalStep - 1 ? widget.lastButtonText : '下一步',
          width: 80,
          onPressed: () async {
            if (_currentIndex == _totalStep - 1) {
              widget.onSubmit();
            } else if (widget.stepList[_currentIndex].stepEnable) {
              await onNextClick();
            }
          },
          disabled: !widget.stepList[_currentIndex].stepEnable,
        ),
        SizedBox(width: 10.0),
      ],
    );
  }

  Widget _buildStepShow() {
    return GestureDetector(
      child: Container(
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Text('第 ${_currentIndex + 1} 步', style: TextStyle(color: _theme.primaryColor)),
            Text('，共 $_totalStep 步'),
            Spacer(),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.35,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          backgroundColor: Colors.transparent,
          builder: (context) {
            return SizedBox(
              height: _totalStep * 80.0,
              child: StepBottomSheet(
                title: widget.title,
                currentIndex: _currentIndex,
                stepList: widget.stepList,
                onSelect: (index) async {
                  Navigator.of(context).pop();
                  await widget.onSelect(index);
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            );
          },
        );
      },
    );
  }

  void onPreviousClick() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        widget.onPreviousClick(_currentIndex);
      });
    }
  }

  Future<void> onNextClick() async {
    if (_currentIndex < _totalStep - 1) {
      await widget.onNextClick(_currentIndex + 1);
      setState(() {
        _currentIndex++;
      });
    }
  }
}
