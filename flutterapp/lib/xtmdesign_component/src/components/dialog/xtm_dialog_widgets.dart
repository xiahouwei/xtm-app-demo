import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

class CustomDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final String leftBtnTitle;
  final String rightBtnTitle;

  /// 文字颜色只在 XTMDialogButtonStyle.text 风格下生效
  final Color leftBtnTitleColor;
  final Color rightBtnTitleColor;
  final bool showCloseIcon;
  final bool showDialogButton;
  final XtmDialogButtonStyle buttonStyle;
  final XtmDialogType dialogType;
  final Widget customContent;

  /// 用于获取自定义UI中的 form 表单对象,进行验证
  final GlobalKey<FormState> formKey;

  const CustomDialogWidget({
    Key key,
    this.title,
    this.message,
    this.leftBtnTitle,
    this.rightBtnTitle,
    this.leftBtnTitleColor,
    this.rightBtnTitleColor,
    this.customContent,
    this.showCloseIcon,
    this.showDialogButton = true,
    this.dialogType,
    this.buttonStyle,
    this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      //设置文字大小不随系统设置改变
      data: MediaQuery.of(context).copyWith(textScaleFactor: xtmDesignConfig.fontScale),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              XTMDialogTitleWidget(
                title: title ?? XtmDialogConstants.defaultTitle,
                showCloseIcon: showCloseIcon,
              ),
              _contentWidget(message, customContent),
              showDialogButton ? _horizontalButtons(context, dialogType, formKey) : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  /// 内容区域
  Widget _contentWidget(String content, Widget customContent) {
    if (customContent != null) {
      return customContent;
    }
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Text(
        content ?? XtmDialogConstants.defaultMessage,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 14 * xtmDesignConfig.fontScale,
            color: Colors.black87,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.normal),
      ),
    );
  }

  /// 底部按钮区域
  Widget _horizontalButtons(
      BuildContext context, XtmDialogType dialogType, GlobalKey<FormState> formKey) {
    final left = XTMDialogButtonOptions(
      title: leftBtnTitle ?? XtmDialogConstants.defaultLeftTitle,
      titleColor: leftBtnTitleColor,
    );
    final right = XTMDialogButtonOptions(
      title: rightBtnTitle ?? XtmDialogConstants.defaultRightTitle,
      titleColor: rightBtnTitleColor,
    );
    return buttonStyle == XtmDialogButtonStyle.text
        ? HorizontalTextButtons(
            leftBtn: left,
            rightBtn: right,
            dialogType: dialogType,
            formKey: formKey,
          )
        : HorizontalNormalButtons(
            leftBtn: left,
            rightBtn: right,
            dialogType: dialogType,
            formKey: formKey,
          );
  }
}

/// 弹窗 title
class XTMDialogTitleWidget extends StatelessWidget {
  const XTMDialogTitleWidget({
    Key key,
    @required this.title,
    this.showCloseIcon,
  }) : super(key: key);

  final String title;

  /// 是否显示关闭按钮
  final bool showCloseIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: showCloseIcon ? EdgeInsets.only(left: 40) : null,
            padding: EdgeInsets.only(top: 15),
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 16 * xtmDesignConfig.fontScale,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none),
            ),
          ),
        ),
        Visibility(
          visible: showCloseIcon,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.all(6.0),
              child: Icon(
                Icons.close,
                size: 22,
                color: Colors.grey,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }
}

class HorizontalNormalButtons extends StatelessWidget {
  /// 左按钮
  final XTMDialogButtonOptions leftBtn;

  /// 右按钮
  final XTMDialogButtonOptions rightBtn;

  /// button 数量
  final XtmDialogType dialogType;

  /// 用于获取当前 form 表单对象
  final GlobalKey<FormState> formKey;

  const HorizontalNormalButtons({
    Key key,
    @required this.leftBtn,
    @required this.rightBtn,
    @required this.dialogType,
    this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: dialogType == XtmDialogType.confirm,
          child: Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 20, bottom: 10),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                child: Center(
                  child: Text(
                    leftBtn.title,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                onPressed: () => Navigator.pop(context, XtmDialogAction.cancel),
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(right: 20, bottom: 10),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: xtmDesignConfig.mainColor,
              ),
              child: Center(
                child: Text(
                  rightBtn.title,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              onPressed: () {
                if (formKey != null) {
                  if (!formKey.currentState.validate()) {
                    return;
                  }
                }
                Navigator.pop(context, XtmDialogAction.confirm);
              },
            ),
          ),
        )
      ],
    );
  }
}

/// 左右横向文字按钮，顶部和中间有分割线
class HorizontalTextButtons extends StatelessWidget {
  /// 左按钮
  final XTMDialogButtonOptions leftBtn;

  /// 右按钮
  final XTMDialogButtonOptions rightBtn;

  /// button 数量
  final XtmDialogType dialogType;

  /// 用于获取当前 form 表单对象
  final GlobalKey<FormState> formKey;

  const HorizontalTextButtons({
    Key key,
    @required this.leftBtn,
    @required this.rightBtn,
    @required this.dialogType,
    this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 1, color: Colors.grey),
        Container(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: dialogType == XtmDialogType.confirm,
                child: Expanded(
                  child: TextButton(
                    child: Text(
                      leftBtn.title,
                      style: TextStyle(color: leftBtn.titleColor ?? Colors.black87),
                    ),
                    style: TextButton.styleFrom(
                      minimumSize: Size(double.infinity, double.infinity),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, XtmDialogAction.cancel),
                  ),
                ),
              ),
              Visibility(
                visible: dialogType == XtmDialogType.confirm,
                child: Container(
                    height: double.infinity,
                    child: const VerticalDivider(
                      width: 2,
                      color: Colors.grey,
                    )),
              ),
              Expanded(
                child: TextButton(
                  child: Text(
                    rightBtn.title,
                    style: TextStyle(color: rightBtn.titleColor ?? xtmDesignConfig.mainColor),
                  ),
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, double.infinity),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  onPressed: () {
                    if (formKey != null) {
                      if (!formKey.currentState.validate()) {
                        return;
                      }
                    }
                    Navigator.pop(context, XtmDialogAction.confirm);
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class XTMDialogButtonOptions {
  XTMDialogButtonOptions({
    @required this.title,
    this.titleColor,
  });

  final String title;

  final Color titleColor;
}
