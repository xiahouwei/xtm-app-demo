import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

/// 输入框样式的表单组件，常用于新增等场景
/// [XtmFormField] 支持输入和只读两种状态展示，默认为输入模式，
/// 支持左右两侧文字的自定义，支持单位的展示[inputRightText],
/// 支持显示默认值[initialValue], 支持输入的实时监听[onEditValue]
///
/// 示例：
/// ```
///  XtmFormField(
///    label: '车牌号',
///    initialValue: _requestModel.vehicleCode ?? '',
///    isRequired: true,
///    showDivider: true,
///    isReadOnly: isEdit,
///    onEditValue: (value) {
///      _requestModel.vehicleCode = value;
///    },
///  )
/// ```

class XtmFormField extends StatefulWidget {
  /// 是否必填
  final bool isRequired;

  /// 左边展示文本
  final String label;

  /// 左边展示文本样式
  final TextStyle labelStyle;

  /// true 只读模式  false 输入模式
  final bool isReadOnly;

  /// 控制器
  final TextEditingController textController;

  /// 输入框输入类型
  final TextInputType inputType;

  /// value 文本样式
  final TextStyle valueStyle;

  /// 输入框最右侧文字，可作为单位
  final String inputRightText;

  /// 输入框初始值
  final String initialValue;

  /// 允许输入的最大长度
  final int maxLength;

  /// 输入框编辑事件
  final void Function(String) onEditValue;

  /// 是否显示分割线
  final bool showDivider;

  /// 输入框焦点
  final FocusNode focusNode;

  /// 输入格式限制器列表
  final List<TextInputFormatter> inputFormatters;

  XtmFormField({
    this.isRequired = false,
    this.label = '',
    this.labelStyle,
    this.showDivider = false,
    this.isReadOnly = false,
    this.inputRightText = '',
    this.textController,
    this.inputType = TextInputType.text,
    this.initialValue = '',
    this.valueStyle,
    this.onEditValue,
    this.maxLength,
    this.focusNode,
    this.inputFormatters,
  });

  @override
  State<XtmFormField> createState() => XtmFormFieldState();
}

class XtmFormFieldState extends State<XtmFormField> with WidgetsBindingObserver {
  TextEditingController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    if (!widget.isReadOnly) {
      _controller = widget.textController ??
          TextEditingController(text: widget.initialValue == null ? '' : widget.initialValue);
      _focusNode = widget.focusNode ?? FocusNode();

      ///监听输入框
      _controller.addListener(() {
        String tempStr = _controller.text == null ? '' : _controller.text;
        if (widget.onEditValue != null) {
          widget.onEditValue(tempStr);
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant XtmFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller != null) {
      if (oldWidget.initialValue != widget.initialValue) {
        _controller.text = widget.initialValue;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 15),
            widget.isRequired
                ? Text('*',
                    strutStyle: StrutStyle(height: 1.5, leading: 0.0, forceStrutHeight: true),
                    style: TextStyle(color: Colors.red))
                : SizedBox(),
            SizedBox(width: 4),
            Text(
              widget.label,
              style: widget.labelStyle ??
                  TextStyle(fontSize: 15, color: xtmDesignConfig.mainTextColor),
            ),
            SizedBox(width: 10),
            Expanded(child: _buildValueContent()),
            widget.inputRightText.isNotEmpty ? SizedBox(width: 10) : SizedBox(),
            Text(widget.inputRightText),
            SizedBox(width: 10),
          ],
        ),
        widget.showDivider
            ? Divider(
                height: 1,
                thickness: 1, // 线粗细
                color: Colors.black12, // 颜色
              )
            : SizedBox(),
      ],
    );
  }

  Widget _buildValueContent() {
    return Container(
      alignment: Alignment.centerRight,
      child: widget.isReadOnly
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 17.0),
              child: Text(
                widget.initialValue,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: widget.valueStyle ??
                    TextStyle(fontSize: 15, color: xtmDesignConfig.mainTextColor),
              ),
            )
          : _buildInputTextField(),
    );
  }

  Widget _buildInputTextField() {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: widget.inputType,
      inputFormatters:
          widget.inputFormatters ?? [LengthLimitingTextInputFormatter(widget.maxLength)],
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: '请输入',
        hintStyle: TextStyle(color: Colors.black45, fontSize: 15),
        border: InputBorder.none,
      ),
      style: widget.valueStyle ?? TextStyle(fontSize: 15, color: xtmDesignConfig.mainTextColor),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _focusNode?.dispose();
    super.dispose();
  }
}
