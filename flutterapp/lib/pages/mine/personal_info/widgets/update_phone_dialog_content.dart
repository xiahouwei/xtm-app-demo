import 'package:flutter/material.dart';
import 'package:flutter_proj/config/api_interface_config/index.dart';
import 'package:flutter_proj/constants/mine_page_constants.dart';
import 'package:flutter_proj/utils/countdown_util.dart';
import 'package:flutter_proj/utils/string_utils.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

class UpdatePhoneDialogContent extends StatefulWidget {
  final String _phone;
  final TextEditingController _phoneController;
  final TextEditingController _codeController;
  final GlobalKey<FormState> _formKey;

  UpdatePhoneDialogContent(
    String phone,
    TextEditingController phoneController,
    TextEditingController codeController,
    GlobalKey<FormState> formKey, {
    Key key,
  })  : _phone = phone,
        _phoneController = phoneController,
        _codeController = codeController,
        _formKey = formKey,
        super(key: key);

  @override
  State<UpdatePhoneDialogContent> createState() => _UpdatePhoneDialogContentState();
}

class _UpdatePhoneDialogContentState extends State<UpdatePhoneDialogContent> {
  GlobalKey<FormFieldState> _phoneKey;
  CountdownTimerUtil _countdownTimer;

  @override
  void initState() {
    super.initState();
    _phoneKey = GlobalKey<FormFieldState>();
    _countdownTimer = CountdownTimerUtil();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Form(
          key: widget._formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('联系方式'),
                  SizedBox(width: 30),
                  Text(widget._phone),
                ],
              ),
              SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: XtmInput(
                      label: '新手机号码',
                      formFieldKey: _phoneKey,
                      inputType: TextInputType.phone,
                      controller: widget._phoneController,
                      clear: true,
                      maxSize: 11,
                      inputFormatters: [
                        XtmInputFormatter.numbersOnly,
                      ],
                      validator: (value) {
                        if (value.isEmpty) {
                          return '请输入手机号码';
                        }
                        if (!StringUtils.isPhoneNum(value)) {
                          return '请输入正确的手机号码';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 5),
                  ValueListenableBuilder(
                    valueListenable: _countdownTimer.remainingSeconds,
                    builder: (context, seconds, child) {
                      return XtmTextButton(
                        text: _countdownTimer.displayText,
                        enabled: _countdownTimer.canSend,
                        onPressed: () => sendCode(),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 15),
              XtmInput(
                label: '短信验证码',
                clear: true,
                inputType: TextInputType.number,
                controller: widget._codeController,
                inputFormatters: [XtmInputFormatter.numbersOnly],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendCode() {
    if (!_phoneKey.currentState.validate()) {
      return;
    }
    String phone = widget._phoneController.text.trim();
    xtmApi.mine.getSmsCode(phone, SmsCodeTypeConstants.TYPE_UPDATE_PHONE).then((value) => {
          _countdownTimer.start(),
          XtmToast.success('验证码已发送'),
        });
  }

  @override
  void dispose() {
    _countdownTimer.stop();
    super.dispose();
  }
}
