import 'package:flutter/material.dart';
import 'package:flutter_proj/models/widget/step_info_model.dart';
import 'package:flutter_proj/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

/// 步进器底部弹窗，自由选择步骤
class StepBottomSheet extends StatefulWidget {
  final String title;
  final List<StepInfoModel> stepList;
  final ValueChanged<int> onSelect;
  final int currentIndex;

  StepBottomSheet({
    Key key,
    @required this.title,
    @required this.currentIndex,
    @required this.stepList,
    @required this.onSelect,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StepBottomSheetState();
}

class _StepBottomSheetState extends State<StepBottomSheet> {
  ThemeNotifier _theme;
  int _currentIndex;
  int _firstDisableIndex = -1;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    // 获取第一个禁用的索引，弹窗中第一个禁用的步骤是指去不了下一页，而当页可到达
    _firstDisableIndex = widget.stepList.indexWhere((element) => element.stepEnable == false);
  }

  @override
  Widget build(BuildContext context) {
    _theme = Provider.of<ThemeNotifier>(context, listen: true);
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: Column(
        children: [
          Text(
            widget.title ?? '提示',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15.0),
          Expanded(child: _buildStepList()),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(_theme.primaryColor),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10.0)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('关闭'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStepList() {
    return ListView.builder(
      itemCount: widget.stepList.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: _buildStepRow(index, widget.stepList[index]),
          onTap: _firstDisableIndex == index || widget.stepList[index].stepEnable
              ? () {
                  setState(() {
                    _currentIndex = index;
                    widget.onSelect(index);
                  });
                }
              : null,
        );
      },
    );
  }

  Widget _buildStepRow(int index, StepInfoModel stepInfo) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13.0),
          child: Text(
            '第 ${index + 1} 步',
            style: _buildTextStyle(index, stepInfo.stepEnable),
          ),
        ),
        SizedBox(width: 10.0),
        Text(
          stepInfo.stepDesc,
          style: _buildTextStyle(index, stepInfo.stepEnable),
        ),
        Expanded(child: Container(color: Colors.white, width: double.infinity, height: 20)),
        Icon(
          stepInfo.stepState == UploadStepState.stepStateUploaded ||
                  stepInfo.stepState == UploadStepState.stepStateSelected
              ? Icons.check_circle
              : Icons.access_time_filled,
          size: 18,
          color: index == _currentIndex ? _theme.primaryColor : Color(0xFFD6DAE1),
        ),
        SizedBox(width: 5.0),
        Text(
          UploadStepState.stepStateStr(stepInfo.stepState),
          style: _buildTextStyle(index, stepInfo.stepEnable),
        ),
      ],
    );
  }

  TextStyle _buildTextStyle(int index, bool enable) {
    if (index == _currentIndex) {
      return TextStyle(color: _theme.primaryColor, fontWeight: FontWeight.bold);
    } else if (enable || index == _firstDisableIndex) {
      return TextStyle(color: Colors.black87);
    } else {
      return TextStyle(color: Colors.grey);
    }
  }
}
