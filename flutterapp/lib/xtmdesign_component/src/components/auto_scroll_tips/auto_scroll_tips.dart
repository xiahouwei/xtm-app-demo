import 'dart:async';

import 'package:flutter/material.dart';

/// 垂直自动轮播提示组件（公告栏）。
///
/// [AutoScrollTips] 用于展示一系列垂直堆叠的提示信息，
/// 组件会自动每隔 3 秒平滑地切换到下一条信息，并支持无限循环播放。
/// 常用于展示系统公告、网站动态或跑马灯消息。
///
/// UI 样式说明：
/// - 背景颜色：浅粉色 (0xFFFAEDEF)
/// - 文字/图标颜色：红色 (0xFFFD0000)
/// - 图标：信息图标 (Icons.info)
///
/// 示例：
/// ```dart
/// AutoScrollTips(
///   tips: [
///     "网站 icons.info 正在出售！",
///     "这里是关于 icons 信息的第一个最佳来源。",
///     "我们希望您找到您正在寻找的内容！",
///   ],
/// )
/// ```

class AutoScrollTips extends StatefulWidget {
  /// 提示信息列表
  final List<String> tips;

  AutoScrollTips({Key key, this.tips}) : super(key: key);

  @override
  State<AutoScrollTips> createState() => AutoScrollViewState();
}

class AutoScrollViewState extends State<AutoScrollTips> {
  PageController _alarmController = PageController(initialPage: 0);
  Timer _timer;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _alarmController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFAEDEF),
        borderRadius: BorderRadius.circular(3),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        controller: _alarmController,
        itemBuilder: (context, index) {
          int realIndex = index % widget.tips.length;
          return _buildAlarmItem(widget.tips[realIndex]);
        },
      ),
    );
  }

  Widget _buildAlarmItem(String alarmTip) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.info, size: 18, color: Color(0xFFFD0000)),
        SizedBox(width: 5),
        Text(
          alarmTip,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: Color(0xFFFD0000)),
        )
      ],
    );
  }

  void startAutoScroll() {
    if (widget.tips == null || widget.tips.isEmpty) return;
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      _currentPageIndex++;
      _alarmController.animateToPage(
        _currentPageIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }
}
