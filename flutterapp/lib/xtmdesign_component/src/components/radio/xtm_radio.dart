import 'package:flutter/material.dart';

/// 单选分组组件，支持泛型类型和自定义选项列表。
///
/// [XtmRadioGroup] 用于在多个选项中选择一个值，
/// 支持传入任意类型（如 enum、String、int 等），
/// 通过 [groupValue] 控制当前选中值，
/// 并通过 [onChanged] 回调将选中结果传递给父组件。
/// 支持可选标题 [title],以及主轴对齐方式 [alignment] 设置。
///
/// 示例：
/// ```dart
/// enum UpdateType { ADDRESS, PHOTO }
///
/// XtmRadioGroup<UpdateType>(
///   title: '上传方式',
///   groupValue: updateTypeSelectValue,
///   onChanged: (value) {
///     setState(() {
///       updateTypeSelectValue = value!;
///     });
///   },
///   options: [
///     XtmRadioOption(label: '上传地址', value: UpdateType.ADDRESS),
///     XtmRadioOption(label: '上传照片', value: UpdateType.PHOTO),
///   ],
/// )
/// ```
class XtmRadioOption<T> {
  final String label;
  final T value;

  XtmRadioOption({
    @required this.label,
    @required this.value,
  });
}

class XtmRadioGroup<T> extends StatelessWidget {
  final String title;
  final List<XtmRadioOption<T>> options;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final MainAxisAlignment mainAxisAlignment;
  final double fontSize;
  const XtmRadioGroup({
    Key key,
    this.title,
    this.fontSize = 15,
    @required this.options,
    @required this.groupValue,
    @required this.onChanged,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              title,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ...options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                child: Row(
                  children: [
                    Icon(
                      groupValue == option.value
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: Colors.blue,
                      size: 20,
                    ),
                    SizedBox(width: 5),
                    Text(
                      option.label,
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ],
                ),
                onTap: () {
                  onChanged(option.value);
                },
              ),
              if (index != options.length - 1) SizedBox(width: 30),
            ],
          );
        }).toList(),
      ],
    );
  }
}
