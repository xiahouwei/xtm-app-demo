import 'dart:async';

import 'package:flutter/material.dart';

class AutoScrollView extends StatefulWidget {
  final List<String> tips;

  AutoScrollView({Key key, this.tips}) : super(key: key);

  @override
  State<AutoScrollView> createState() => AutoScrollViewState();
}

class AutoScrollViewState extends State<AutoScrollView> {
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
