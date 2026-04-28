import 'package:flutter/material.dart';

/// 步骤进度组件，支持自定义步骤列表和当前激活步骤。
///
/// [XtmStepProgress] 用于展示一个垂直的步骤列表，
/// - 每个步骤可显示已完成、当前激活或未完成状态。
/// 支持自定义步骤标题，通过 [activeIndex] 控制当前激活步骤。
///
/// 示例：
/// ```dart
/// List<XtmStepProgressOption> steps = [
///   XtmStepProgressOption(title: '请在围栏等待'),
///   XtmStepProgressOption(title: '请驶出围栏，通过安保卡口进入南路等待'),
///   XtmStepProgressOption(title: '请在南路排队，等待商务卡口验证进入堆场'),
///   XtmStepProgressOption(title: '请通过商务卡口进入堆场'),
///   XtmStepProgressOption(title: '已过皮等待铲车刷卡，装车'),
///   XtmStepProgressOption(title: '铲车已刷卡，装车完成后，请过重磅苦盖后驶出港区'),
///   XtmStepProgressOption(title: '请过重磅苦盖后驶出港区'),
/// ];
///
/// XtmStepProgress(
///   steps: steps,
///   activeIndex: 3,
/// )
/// ```
class XtmStepProgressOption<T> {
  final String title;

  XtmStepProgressOption({
    @required this.title,
  });
}

class XtmStepProgress extends StatefulWidget {
  final List<XtmStepProgressOption> steps;
  final int activeIndex;
  XtmStepProgress({
    @required this.steps,
    @required this.activeIndex,
  });
  @override
  State<XtmStepProgress> createState() => _XtmStepProgressState();
}

class _XtmStepProgressState extends State<XtmStepProgress> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDialogBody();
  }

  Widget _buildDialogBody() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      itemCount: widget.steps.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => _buildStepItem(index),
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox();
      },
    );
  }

  Widget _buildStepItem(int index) {
    final bool isCompleted = index < widget.activeIndex;
    final bool isActive = index == widget.activeIndex;
    final bool isLast = index == widget.steps.length - 1;
    final stepData = widget.steps[index];
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepIndicator(isCompleted: isCompleted, isActive: isActive, isLast: isLast),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stepData.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted || isActive ? Colors.black87 : Colors.grey,
                  ),
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetpIcon({
    bool isCompleted,
    bool isActive,
    bool isLast,
  }) {
    if (isActive && isLast) {
      return Container(
        width: 18,
        height: 18,
        decoration: const BoxDecoration(
          color: Color(0xFF1677FF),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 16),
      );
    }
    if (isCompleted) {
      return Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: Color(0xFF1677FF),
          shape: BoxShape.circle,
        ),
      );
    }
    if (isActive) {
      return Container(
        alignment: Alignment.center,
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: Color(0xFFE8F0FF),
          shape: BoxShape.circle,
        ),
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Color(0xFF1677FF),
            shape: BoxShape.circle,
          ),
        ),
      );
    }
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildStepIndicator({
    bool isCompleted,
    bool isActive,
    bool isLast,
  }) {
    return Container(
      width: 30,
      alignment: Alignment.center,
      child: Transform.translate(
        offset: Offset(0, 4),
        child: Column(
          children: [
            _buildSetpIcon(isCompleted: isCompleted, isActive: isActive, isLast: isLast),
            Visibility(
              visible: !isLast,
              child: Expanded(
                child: Container(
                  width: 2,
                  color: isCompleted ? Colors.blue : Colors.grey[300],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
