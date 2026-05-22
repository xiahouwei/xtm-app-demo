import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import '../../utils/xtm_async_utils.dart';

/// 底部筛选器工具类，用于展示全屏或半屏的底部弹窗。
///
/// [XtmBottomFilter] 封装了 [showModalBottomSheet]，
/// 结合 [XtmAsyncUtils] 以 Promise 的形式返回结果，
/// 方便在业务逻辑中通过 `await` 获取用户的选择。

class XtmBottomFilter {
  static Future<T> showBottomFilter<T>(
    BuildContext context, {
    Widget Function(BuildContext) builder,
  }) async {
    return XtmAsyncUtils.PromiseFunction<T>((promise) async {
      final result = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.6),
        builder: (ctx) {
          return builder(context);
        },
      );
      if (result != null) {
        promise.complete(result as T);
      }
    });
  }
}

/// 底部筛选器面板的数据模型。
///
/// 用于定义 [XtmBottomFilterTab] 中每一个 Tab 页的标题和对应的内容组件。
class XtmBottomFilterPanel {
  /// 每个分页的中文标题
  final String label;

  /// 每个分页渲染的UI
  final Widget widget;

  XtmBottomFilterPanel({
    @required this.label,
    @required this.widget,
  });
}

/// 底部筛选器 Tab 切换组件。
///
/// [XtmBottomFilterTab] 提供了一个带有左侧 Tab 导航栏的底部筛选面板，
/// 支持通过 [filterList] 传入多个筛选维度的页面，
/// 并内置了“重置”和“确定”按钮，通过 [onReset] 和 [onConfirm] 回调处理业务逻辑。
///
/// 示例：
/// ```dart
/// XtmBottomFilterTab(
///   filterList: [
///     XtmBottomFilterPanel(
///       label: '区域',
///       widget: AreaFilterWidget(),
///     ),
///     XtmBottomFilterPanel(
///       label: '价格',
///       widget: PriceFilterWidget(),
///     ),
///   ],
///   onReset: () {
///     // 处理重置逻辑
///   },
///   onConfirm: () {
///     // 处理确认逻辑，通常配合 Navigator.pop 关闭弹窗
///     Navigator.of(context).pop(resultData);
///   },
/// )
/// ```

class XtmBottomFilterTab extends StatefulWidget {
  /// 筛选面板列表，包含每个 Tab 的标题和内容
  final List<XtmBottomFilterPanel> filterList;

  /// 重置按钮点击事件
  final Function onReset;

  /// 确认按钮点击事件
  final Function onConfirm;
  XtmBottomFilterTab({
    Key key,
    @required this.filterList,
    this.onReset,
    this.onConfirm,
  }) : super(key: key);
  @override
  State<XtmBottomFilterTab> createState() => XtmBottomFilterTabState();
}

class XtmBottomFilterTabState extends State<XtmBottomFilterTab> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
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
                  '条件筛选',
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: xtmDesignConfig.unSelectBgColor,
                  height: double.infinity,
                  child: Column(
                    children: List.generate(
                        widget.filterList.length, (index) => _buildFilterTabItem(index)),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(child: _buildFilterTabViews()),
              ],
            ),
          ),
          _buttons(),
        ],
      ),
    );
  }

  Widget _buildFilterTabItem(int index) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        width: 100,
        child: Center(
          child: Text(
            widget.filterList[index].label,
            style: TextStyle(
              color: _currentIndex == index
                  ? xtmDesignConfig.mainTextColor
                  : xtmDesignConfig.titleTextColor,
              fontSize: _currentIndex == index ? 16 : 14,
              fontWeight: _currentIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Widget _buildFilterTabViews() {
    return Stack(
      children: List.generate(widget.filterList.length, (index) {
        return Visibility(
          visible: _currentIndex == index,
          maintainState: true,
          child: widget.filterList[index].widget,
        );
      }),
    );
  }

  Widget _buttons() {
    return Container(
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
                if (widget.onReset != null) {
                  widget.onReset();
                }
              },
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: XtmTextButton(
              text: '确定',
              onPressed: () {
                if (widget.onConfirm != null) {
                  widget.onConfirm();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
