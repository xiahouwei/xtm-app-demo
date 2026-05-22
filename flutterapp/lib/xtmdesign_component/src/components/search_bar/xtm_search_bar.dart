import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

/// 搜索栏组件，集成了输入框与搜索按钮。
///
/// [XtmSearchBar] 内部封装了 [XtmInput] 与 [XtmTextButton]，
/// 自动添加了搜索图标前缀和“搜索”按钮后缀。
/// 点击搜索按钮或触发搜索时，会通过 [onSearch] 回调返回当前输入的文本，
/// 并自动收起键盘。
///
/// 示例：
/// ```dart
/// // 在 State 中定义控制器
/// final TextEditingController _searchController = TextEditingController();
///
/// XtmSearchBar(
///   controller: _searchController,
///   label: '商品名称', // 实际显示的 placeholder 为 "请输入商品名称"
///   onSearch: (value) {
///     print('开始搜索:  $ value');
///   },
/// )
/// ```
class XtmSearchBar extends StatefulWidget {
  /// 输入框的文本控制器
  final TextEditingController controller;

  /// placeholder文本, 会自动增加前缀"请输入"
  final String label;

  /// 搜索事件
  final ValueChanged<String> onSearch;

  XtmSearchBar({
    Key key,
    @required this.controller,
    @required this.label,
    this.onSearch,
  }) : super(key: key);
  @override
  State<XtmSearchBar> createState() => XtmSearchBarState();
}

class XtmSearchBarState extends State<XtmSearchBar> {
  String get searchValue => (widget.controller.text ?? '').trim();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: XtmInput(
        label: widget.label,
        useHint: true,
        clear: true,
        controller: widget.controller,
        borderColor: Colors.white,
        inputType: TextInputType.text,
        prefix: Icon(Icons.manage_search, size: 24),
        suffix: XtmTextButton(
          text: '搜索',
          height: 38,
          onPressed: () {
            setState(() {
              if (widget.onSearch != null) {
                widget.onSearch(searchValue);
              }
              FocusScope.of(context).unfocus();
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
