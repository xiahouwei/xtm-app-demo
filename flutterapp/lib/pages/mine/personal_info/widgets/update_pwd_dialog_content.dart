import 'package:flutter/material.dart';
import 'package:flutter_proj/config/api_interface_config/index.dart';
import 'package:flutter_proj/constants/mine_page_constants.dart';
import 'package:flutter_proj/utils/countdown_util.dart';
import 'package:flutter_proj/utils/string_utils.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

import 'dialog_actions.dart';

class UpdatePwdDialogContent extends StatefulWidget {
  final String phone;
  final GlobalKey<FormState> formKey;
  final Function(
    bool isForgetPwd,
    String smsCode,
    String oldPwd,
    String newPwd,
  ) onConfirmed;

  UpdatePwdDialogContent({
    this.phone,
    this.formKey,
    this.onConfirmed,
  });

  @override
  State<UpdatePwdDialogContent> createState() => _UpdatePwdDialogContentState();
}

class _UpdatePwdDialogContentState extends State<UpdatePwdDialogContent> {
  CountdownTimerUtil _countdownTimer;
  TextEditingController _oldPwdController;
  TextEditingController _newPwdController;
  TextEditingController _confirmPwdController;
  TextEditingController _smsCodeController;

  bool oldObscureText = true;
  bool newObscureText = true;
  bool confirmObscureText = true;
  bool forgetPwd = false;

  @override
  void initState() {
    super.initState();
    _countdownTimer = CountdownTimerUtil();
    _oldPwdController = TextEditingController();
    _newPwdController = TextEditingController();
    _confirmPwdController = TextEditingController();
    _smsCodeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width - 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Form(
            key: widget.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                XTMDialogTitleWidget(title: '修改密码', showCloseIcon: false),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      _buildForgetPwdContent(),
                      _buildUpdatePwdContent(),
                      SizedBox(height: 15),
                      ..._buildPwdContent(),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                DialogActions(
                  onConfirmed: () => widget.onConfirmed(
                    forgetPwd,
                    _smsCodeController.text.trim(),
                    _oldPwdController.text.trim(),
                    _newPwdController.text.trim(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgetPwdContent() {
    return Visibility(
      visible: forgetPwd,
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Text('联系方式'),
              SizedBox(width: 30),
              Text(widget.phone),
            ],
          ),
          SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: XtmInput(
                  label: '验证码',
                  inputType: TextInputType.number,
                  controller: _smsCodeController,
                ),
              ),
              SizedBox(width: 10),
              ValueListenableBuilder(
                  valueListenable: _countdownTimer.remainingSeconds,
                  builder: (context, seconds, child) {
                    return XtmTextButton(
                      text: _countdownTimer.displayText,
                      enabled: _countdownTimer.canSend,
                      onPressed: () => sendCode(),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpdatePwdContent() {
    return Visibility(
      visible: !forgetPwd,
      child: Column(
        children: [
          SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: XtmInput(
                  label: '旧密码',
                  inputType: TextInputType.visiblePassword,
                  controller: _oldPwdController,
                  obscureText: oldObscureText,
                  suffix: oldEyeButton(),
                ),
              ),
              SizedBox(width: 10),
              XtmTextButton(
                text: '忘记密码',
                onPressed: () {
                  widget.formKey.currentState.reset();
                  setState(() {
                    forgetPwd = true;
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPwdContent() {
    return [
      XtmInput(
        label: '新密码',
        inputType: TextInputType.visiblePassword,
        controller: _newPwdController,
        obscureText: newObscureText,
        suffix: newEyeButton(),
        validator: (value) {
          if (!StringUtils.isStrongPassword(value.trim())) {
            return '请输入8位以上数字和大小写字母的组合';
          }
          return null;
        },
      ),
      SizedBox(height: 15),
      XtmInput(
        label: '确认密码',
        inputType: TextInputType.visiblePassword,
        controller: _confirmPwdController,
        obscureText: confirmObscureText,
        suffix: confirmEyeButton(),
        validator: (value) {
          if (value.trim().isEmpty) {
            return '请输入确认密码';
          }
          if (value.trim() != _newPwdController.text.trim()) {
            return '两次密码不一致';
          }
          return null;
        },
      )
    ];
  }

  Widget oldEyeButton() {
    String imageName = 'login_eye_close.png';
    if (!oldObscureText) {
      imageName = 'login_eye_open.png';
    }
    return GestureDetector(
      child: Image.asset(
        'assets/images/login/$imageName',
        width: 23,
        height: 23,
      ),
      onTap: () {
        setState(() {
          oldObscureText = !oldObscureText;
        });
      },
    );
  }

  Widget newEyeButton() {
    String imageName = 'login_eye_close.png';
    if (!newObscureText) {
      imageName = 'login_eye_open.png';
    }
    return GestureDetector(
      child: Image.asset(
        'assets/images/login/$imageName',
        width: 23,
        height: 23,
      ),
      onTap: () {
        setState(() {
          newObscureText = !newObscureText;
        });
      },
    );
  }

  Widget confirmEyeButton() {
    String imageName = 'login_eye_close.png';
    if (!confirmObscureText) {
      imageName = 'login_eye_open.png';
    }
    return GestureDetector(
      child: Image.asset(
        'assets/images/login/$imageName',
        width: 23,
        height: 23,
      ),
      onTap: () {
        setState(() {
          confirmObscureText = !confirmObscureText;
        });
      },
    );
  }

  void sendCode() {
    xtmApi.mine
        .getSmsCode(widget.phone, SmsCodeTypeConstants.TYPE_UPDATE_PWD)
        .then((value) => {_countdownTimer.start(), XtmToast.success('验证码已发送')});
  }

  @override
  void dispose() {
    _countdownTimer.stop();
    super.dispose();
  }
}
