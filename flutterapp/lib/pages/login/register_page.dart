import 'package:flutter/material.dart';
import 'package:flutter_proj/config/api_interface_config/index.dart';
import 'package:flutter_proj/utils/countdown_util.dart';
import 'package:flutter_proj/utils/string_utils.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

import './widgets/register_password_input.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage();

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _idCardController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _validateCodeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  bool secure = false;

  CountdownTimerUtil _countdownTimer;

  @override
  void initState() {
    super.initState();
    _countdownTimer = CountdownTimerUtil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: XtmAppBar(title: '注册成为司机'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15),
                    XtmInput(
                      label: '姓名',
                      controller: _nameController,
                      clear: true,
                    ),
                    SizedBox(height: 15),
                    XtmInput(
                      label: '身份证号',
                      controller: _idCardController,
                      inputType: TextInputType.number,
                      clear: true,
                      validator: (value) {
                        if (!StringUtils.verifyCardId(value)) {
                          return '身份证号格式有误，请重新输入';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    XtmInput(
                      label: '手机号码',
                      controller: _phoneController,
                      inputType: TextInputType.number,
                      clear: true,
                      maxSize: 11,
                      inputFormatters: [XtmInputFormatter.numbersOnly],
                      validator: (value) {
                        if (!StringUtils.isPhoneNum(value)) {
                          return '手机号码格式有误，请重新输入';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    XtmInput(
                      label: '验证码',
                      controller: _validateCodeController,
                      inputType: TextInputType.number,
                      clear: true,
                      inputFormatters: [XtmInputFormatter.numbersOnly],
                      suffix: ValueListenableBuilder(
                        valueListenable: _countdownTimer.remainingSeconds,
                        builder: (context, value, child) {
                          return GestureDetector(
                            onTap: () {
                              if (_countdownTimer.canSend) {
                                getSmsCodeByMobileWithRegister();
                              }
                            },
                            child: Text(
                              _countdownTimer.displayText,
                              style: TextStyle(color: Colors.blue, fontSize: 14),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                    RegisterPasswordInput(
                      label: '密码',
                      controller: _passwordController,
                      validator: (value) {
                        if (!StringUtils.isStrongPassword(value.trim())) {
                          return '请输入8位以上数字和大小写字母的组合';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    RegisterPasswordInput(
                      label: '确认密码',
                      controller: _newPasswordController,
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return '请输入确认密码';
                        }
                        if (value.trim() != _passwordController.text.trim()) {
                          return '两次密码输入不一致,请重新输入';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    XtmTextButton(
                      text: '确认',
                      fontSize: 16,
                      width: double.infinity,
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        registerHandler();
                      },
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getSmsCodeByMobileWithRegister() {
    if (_phoneController.text.trim().isEmpty) {
      XtmToast.warn('请输入手机号');
      return false;
    }
    xtmApi.auth
        .getSmsCodeByMobileWithRegiste(mobile: _phoneController.text.trim())
        .then((value) => {_countdownTimer.start(), XtmToast.success('已获取验证码')});
  }

  registerHandler() {
    Map<String, dynamic> params = {
      'name': _nameController.text.trim(),
      'identityCard': _idCardController.text.trim(),
      'mobile': _phoneController.text.trim(),
      'smsCode': _validateCodeController.text.trim(),
      'password': _passwordController.text.trim(),
    };
    xtmApi.auth.registerUser(params: params).then((res) {
      XtmToast.success('注册成功');
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _countdownTimer.stop();
    super.dispose();
  }
}
