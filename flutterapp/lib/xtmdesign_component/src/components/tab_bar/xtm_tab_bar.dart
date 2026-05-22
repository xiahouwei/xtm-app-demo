import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

/// 通用 Tab 切换组件，支持自定义 Tab 标题与内容视图。
///
/// [XtmTabBar] 基于 Flutter 原生 [TabBar] + [TabBarView] 封装，
/// 用于快速构建带内容切换的标签页布局。
///
/// 支持通过 [tabList] 传入多个 Tab 配置，每个 Tab 包含：
/// - [XtmTab.title]：Tab 标题
/// - [XtmTab.widget]：对应展示内容
///
/// 可通过 [onChanged] 监听 Tab 切换事件（仅点击触发，不包含滑动切换）。
///
/// [initialIndex] 用于设置默认选中的 Tab（默认值为 0）。
///
/// 示例：
/// ```dart
/// XtmTabBar<int>(
///   tabList: [
///     XtmTab(
///       title: '全部',
///       widget: Center(child: Text('全部内容')),
///     ),
///     XtmTab(
///       title: '需更新',
///       widget: Center(child: Text('需更新内容')),
///     ),
///   ],
/// )
/// ```
/// 如果需要设置默认激活页, 和处理切换事件
/// ```dart
/// XtmTabBar<int>(
///   initialIndex: 1,
///   onChanged: (index) {
///     print('当前选中 Tab: $index');
///   },
///   tabList: [
///     XtmTab(
///       title: '全部',
///       widget: Center(child: Text('全部内容')),
///     ),
///     XtmTab(
///       title: '需更新',
///       widget: Center(child: Text('需更新内容')),
///     ),
///   ],
/// )
/// ```
class XtmTab {
  final String title;
  final Widget widget;

  XtmTab({
    @required this.title,
    @required this.widget,
  });
}

class XtmTabBar extends StatefulWidget {
  /// 分页数据
  final List<XtmTab> tabList;

  /// 切换事件
  final ValueChanged<int> onChanged;

  /// 默认激活页面索引
  final int initialIndex;
  XtmTabBar({
    Key key,
    @required this.tabList,
    this.initialIndex = 0,
    this.onChanged,
  }) : super(key: key);
  @override
  State<XtmTabBar> createState() => XtmTabBarState();
}

class XtmTabBarState extends State<XtmTabBar> with SingleTickerProviderStateMixin {
  TabController _controller;
  int get currentIndex => _controller.index;
  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: widget.tabList.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            controller: _controller,
            isScrollable: false,
            indicatorColor: xtmDesignConfig.mainColor,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.normal,
            ),
            labelColor: xtmDesignConfig.mainColor,
            unselectedLabelColor: xtmDesignConfig.titleTextColor,
            tabs: widget.tabList.map((e) => Tab(text: e.title)).toList(),
            onTap: (index) {
              if (widget.onChanged != null) {
                widget.onChanged(index);
              }
            }),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: widget.tabList.map((e) => e.widget).toList(),
          ),
        )
      ],
    );
  }

  void switchTo(int index) {
    _controller.animateTo(index);
  }

  void next() {
    int nextIndex = (_controller.index + 1) == widget.tabList.length ? 0 : (_controller.index + 1);
    _controller.animateTo(nextIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
