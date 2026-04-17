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
///   XtmStepProgressOption(title: '派单', content: '互联互通（天津小铁马科技有限公司）', datetime: '2025-01-01 23:59:59'),
///   XtmStepProgressOption(title: '录入原发', content: ''),
///   XtmStepProgressOption(title: '签到打卡', content: '当前未通知进厂，请耐心等待！'),
/// ];
///
/// XtmStepProgress(
///   steps: steps,
///   activeIndex: 1,
/// )
/// ```
class XtmStepProgressOption<T> {
  final String title;
  final String content;
  final String datetime;

  XtmStepProgressOption({
    @required this.title,
    this.content,
    this.datetime,
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
          _buildStepIndicator(
              isCompleted: isCompleted, isActive: isActive, isLast: isLast),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        stepData.title ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
                          color: isCompleted || isActive
                              ? Colors.black87
                              : Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      stepData.datetime ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  stepData.content ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16)
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
            _buildSetpIcon(
                isCompleted: isCompleted, isActive: isActive, isLast: isLast),
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
