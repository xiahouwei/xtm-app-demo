import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

enum XtmEmptyType { plain, operation }

/// 展示空布局的组件
/// [XtmEmptyView] 提供了默认的空布局UI，
/// 提供了默认的图片和文案，支持通过参数更换图片和文案，
/// 提供两种方案，纯文本展示无数据[XtmEmptyType.plain]，
/// 和带有操作按钮的的空布局[XtmEmptyType.operation],默认的操作按钮可以添加点击事件，
/// 支持自定义操作区域UI
///
/// 示例：
/// ```
///  XtmEmptyView(
///     emptyText: '当前暂无执行中派车单，快去接单吧！',
///     operationText: '跳转派车单',
///     type: XtmEmptyType.operation,
///     onTapEvent: () {
///     },
///  )
/// ```

class XtmEmptyView extends StatelessWidget {
  const XtmEmptyView({
    this.type = XtmEmptyType.plain,
    this.image,
    this.emptyText,
    this.operationText,
    this.onTapEvent,
    this.emptyTextColor,
    this.customOperationWidget,
    Key key,
  }) : super(key: key);

  /// 展示图片
  final Widget image;

  /// 描述文字
  final String emptyText;

  /// 描述文字颜色
  final Color emptyTextColor;

  /// 操作按钮文案
  final String operationText;

  /// 类型，为operation有操作按钮，plain无按钮
  final XtmEmptyType type;

  /// 自定义操作按钮
  final Widget customOperationWidget;

  /// 点击事件
  final Function() onTapEvent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        image ?? Image.asset('lib/xtmdesign_component/assets/images/list_no_date.png', width: 180),
        Text(
          emptyText ?? '暂无相关数据',
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.black54, fontSize: 15),
        ),
        type == XtmEmptyType.operation
            ? customOperationWidget ??
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: XtmTextButton(
                    text: operationText ?? '',
                    onPressed: () {
                      if (onTapEvent != null) {
                        onTapEvent();
                      }
                    },
                  ),
                )
            : Container(margin: EdgeInsets.only(bottom: 20))
      ],
    );
  }
}
