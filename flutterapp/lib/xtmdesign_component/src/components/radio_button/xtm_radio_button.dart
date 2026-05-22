import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

/// 单选按钮分组组件，支持泛型类型和自定义选项列表。
///
/// [XtmRadioGroup] 用于在多个选项中选择一个值，
/// 支持传入任意类型（如 enum、String、int 等），
/// 通过 [groupValue] 控制当前选中值，
/// 并通过 [onChanged] 回调将选中结果传递给父组件。
///
/// 示例：
/// ```dart
/// enum UpdateType { ADDRESS, PHOTO }
///
/// XtmRadioButtonGroup<UpdateType>(
///   groupValue: updateTypeSelectValue,
///   onChanged: (value) {
///     setState(() {
///       updateTypeSelectValue = value!;
///     });
///   },
///   options: [
///     XtmRadioButtonOption(label: '上传地址', value: UpdateType.ADDRESS),
///     XtmRadioButtonOption(label: '上传照片', value: UpdateType.PHOTO),
///   ],
/// )
/// ```
class XtmRadioButtonOption<T> {
  final String label;
  final T value;
  final bool disabled;

  XtmRadioButtonOption({
    @required this.label,
    @required this.value,
    this.disabled = false,
  });
}

class XtmRadioButtonGroup<T> extends StatelessWidget {
  /// 选项
  final List<XtmRadioButtonOption<T>> options;

  /// 激活值
  final T groupValue;

  /// 切换事件
  final ValueChanged<T> onChanged;

  const XtmRadioButtonGroup({
    Key key,
    @required this.options,
    @required this.groupValue,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(options.length * 2 - 1, (index) {
        if (index.isOdd) {
          return SizedBox(width: 8);
        }

        final realIndex = index ~/ 2;
        final item = options[realIndex];
        final selected = groupValue == item.value;

        return Expanded(
          child: XtmTextButton(
            text: item.label,
            disabled: item.disabled,
            height: 30,
            fontSize: 14,
            horizontalPadding: 6,
            type: selected ? XtmTextButtonType.PRIMARY : XtmTextButtonType.INFO,
            onPressed: () {
              onChanged(item.value);
            },
          ),
        );
      }),
    );
  }
}
