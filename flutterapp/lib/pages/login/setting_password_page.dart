import 'package:flutter/material.dart';
import 'package:flutter_proj/config/api_interface_config/index.dart';
import 'package:flutter_proj/routes/app_router_constant.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

class SettingPasswordPage extends StatefulWidget {
  final String userId;
  final String mobile;

  SettingPasswordPage({@required this.userId, @required this.mobile});

  @override
  State<SettingPasswordPage> createState() => _SettingPasswordPageState();
}

class _SettingPasswordPageState extends State<SettingPasswordPage> {
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _newPwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void settingPasswordRequest() {
    String _pwsStr = _pwdController.text.trim();
    String _newPwsStr = _newPwdController.text.trim();
    if (_pwsStr == null || _pwsStr.isEmpty) {
      XtmToast.info('请输入密码');
      return;
    }
    if (_pwsStr.length < 6) {
      XtmToast.warn('密码必须大于等于6位');
      return;
    }
    if (_newPwsStr == null || _newPwsStr.isEmpty) {
      XtmToast.info('请确认输入密码');
      return;
    }
    if (_pwsStr != _newPwsStr) {
      XtmToast.warn('两次密码输入不一致');
      return;
    }
    Map params = {};
    params['id'] = widget.userId;
    params['password'] = _pwsStr;
    xtmApi.auth.setPassword(params: params).then((res) {
      XtmToast.success('密码设置成功');
      Future.delayed(Duration(seconds: 1)).then((value) => changeRootPageAndLoginStatus());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XtmAppBar(title: '设置登录密码'),
      body: GestureDetector(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 45,
                ),
                Text(
                  '当前手机号：${widget.mobile}',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                SizedBox(
                  height: 20,
                ),
                buildPasswordInput(),
                SizedBox(
                  height: 20,
                ),
                buildNewPasswordInput(),
                SizedBox(
                  height: 40,
                ),
                buildConfirmBtn(),
              ],
            ),
          ),
        ),
        onTap: () => FocusManager.instance.primaryFocus.unfocus(),
      ),
    );
  }

  Widget buildPasswordInput() {
    return Container(
      width: MediaQuery.of(context).size.width - 80,
      child: XtmInput(
        label: '密码',
        inputType: TextInputType.visiblePassword,
        controller: _newPwdController,
      ),
    );
  }

  Widget buildNewPasswordInput() {
    return Container(
      width: MediaQuery.of(context).size.width - 80,
      child: XtmInput(
        label: '确认密码',
        inputType: TextInputType.visiblePassword,
        controller: _pwdController,
      ),
    );
  }

  Widget buildConfirmBtn() {
    return Container(
      width: MediaQuery.of(context).size.width - 80,
      child: XtmTextButton(
        text: '确认',
        fontSize: 16,
        width: double.infinity,
        onPressed: () {
          settingPasswordRequest();
        },
      ),
    );
  }

  void changeRootPageAndLoginStatus() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouterNameConstant.MAIN,
      (route) => false,
    );
  }
}
