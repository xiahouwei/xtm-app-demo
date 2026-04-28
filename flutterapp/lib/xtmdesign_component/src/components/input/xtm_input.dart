import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

/// 可定制输入框组件，支持表单验证、只读模式以及右侧自定义控件。
///
/// [XtmInput] 支持文本输入、数字输入、密码输入等类型，可选择显示
/// 提示文本或标签，支持输入格式限制和最大长度。可以在输入框右侧
/// 添加自定义后缀控件，例如“获取验证码”按钮。
///
/// 示例：
/// ```dart
/// XtmInput(
///   label: '验证码',
///   controller: _codeController,
///   maxSize: 6,
///   inputType: TextInputType.number,
///   suffix: GestureDetector(
///     onTap: () { print('获取验证码'); },
///     child: Text('获取验证码', style: TextStyle(color: Colors.blue)),
///   ),
/// )
/// ```
class XtmInput extends StatefulWidget {
  /// 输入框标签
  final String label;

  /// 初始值，当未使用 [controller] 时显示
  final String value;

  /// 文本控制器，用于获取或修改输入内容
  final TextEditingController controller;

  /// 是否使用提示文本（placeholder）
  final bool useHint;

  /// 最大输入长度
  final int maxSize;

  /// 输入类型，如文本、数字、密码
  final TextInputType inputType;

  /// 输入格式限制器列表
  final List<TextInputFormatter> inputFormatters;

  /// 表单验证函数
  final FormFieldValidator<String> validator;

  /// 可用于某一字段的单独校验
  final GlobalKey<FormFieldState> formFieldKey;

  /// 焦点控制
  final FocusNode focusNode;

  /// 输入框左侧自定义控件
  final Widget prefix;

  /// 输入框右侧自定义控件，例如“获取验证码”按钮
  final Widget suffix;

  /// 输入框清空功能
  final bool clear;

  /// 边框颜色
  final Color borderColor;

  const XtmInput({
    this.label,
    this.value,
    this.controller,
    this.useHint = false,
    this.maxSize = 20,
    this.inputType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.focusNode,
    this.prefix,
    this.suffix,
    this.clear = false,
    this.borderColor,
    this.formFieldKey,
  });

  @override
  State<XtmInput> createState() => _XtmInputState();
}

class _XtmInputState extends State<XtmInput> {
  FocusNode _focusNode;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    // 密码类型时，默认不显示密码
    _obscureText = widget.inputType == TextInputType.visiblePassword;
  }

  @override
  void didUpdateWidget(covariant XtmInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.inputType != oldWidget.inputType) {
      setState(() {
        _obscureText = widget.inputType == TextInputType.visiblePassword;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildTextFormField();
  }

  Widget _buildTextFormField() {
    return Container(
      constraints: BoxConstraints(minHeight: 48.0),
      child: TextFormField(
        key: widget.formFieldKey,
        focusNode: _focusNode,
        controller: widget.controller,
        textAlignVertical: TextAlignVertical.center,
        validator:
            widget.validator ?? (value) => value.trim().isEmpty ? '请输入${widget.label}' : null,
        cursorColor: xtmDesignConfig.mainColor.withOpacity(0.6),
        decoration: InputDecoration(
          prefixIcon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: widget.prefix ?? SizedBox(),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 0),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          fillColor: Colors.white,
          filled: true,
          hintText: widget.useHint ? '请输入${widget.label}' : null,
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
          labelText: widget.useHint ? null : '请输入${widget.label}',
          labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
          errorStyle: TextStyle(fontSize: 12),
          floatingLabelStyle: TextStyle(fontSize: 15, color: xtmDesignConfig.mainColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: widget.borderColor ?? xtmDesignConfig.mainColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: widget.borderColor ?? xtmDesignConfig.mainColor),
          ),
          suffixIcon: Container(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.clear
                    ? ValueListenableBuilder(
                        valueListenable: widget.controller,
                        builder: (context, value, child) {
                          return value.text.isNotEmpty
                              ? GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(Icons.cancel, size: 20, color: Colors.grey),
                                  ),
                                  onTap: () {
                                    widget.controller.clear();
                                  },
                                )
                              : SizedBox();
                        },
                      )
                    : SizedBox(),
                widget.inputType == TextInputType.visiblePassword ? _showPwd() : SizedBox(),
                widget.suffix != null ? widget.suffix : SizedBox(),
              ],
            ),
          ),
        ),
        keyboardType: widget.inputType,
        obscureText: _obscureText,
        inputFormatters: widget.inputFormatters == null
            ? [LengthLimitingTextInputFormatter(widget.maxSize)]
            : [LengthLimitingTextInputFormatter(widget.maxSize), ...widget.inputFormatters],
      ),
    );
  }

  Widget _showPwd() {
    String imageName = 'login_eye_close.png';
    if (!_obscureText) {
      imageName = 'login_eye_open.png';
    }
    return GestureDetector(
      child: Image.asset(
        'lib/xtmdesign_component/assets/images/$imageName',
        width: 20,
        height: 20,
      ),
      onTap: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    widget.controller?.dispose();
    super.dispose();
  }
}
