import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_proj/config/api_interface_config/index.dart';
import 'package:flutter_proj/models/login/user_info_model.dart';
import 'package:flutter_proj/pages/mine/personal_info/widgets/update_phone_dialog_content.dart';
import 'package:flutter_proj/pages/mine/personal_info/widgets/update_pwd_dialog_content.dart';
import 'package:flutter_proj/routes/app_router_constant.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/theme/xtm_color.dart';
import 'package:flutter_proj/utils/string_utils.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

class PersonalInfoPage extends StatefulWidget {
  final UserInfoModel userInfo;

  PersonalInfoPage({Key key, this.userInfo}) : super(key: key);

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  UserInfoModel _userInfo;
  bool dataChanged = false;

  @override
  void initState() {
    super.initState();
    _userInfo = widget.userInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: XtmAppBar(
        title: '个人信息',
        popParams: {'dataChanged': dataChanged},
      ),
      backgroundColor: XtmColor.bgColor,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        margin: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            XtmCell(
              label: '姓名',
              value: _userInfo.userName,
              rightWidget: XtmTextButton(
                text: '修改',
                height: 40,
                onPressed: () {
                  showEditDialog('姓名', _userInfo.userName).then((name) {
                    if (name != _userInfo.userName) {
                      updateName(name);
                    }
                  });
                },
              ),
            ),
            XtmCell(
              label: '联系方式',
              value: _userInfo.mobile,
              rightWidget: XtmTextButton(
                text: '修改',
                height: 40,
                onPressed: () {
                  showEditPhoneDialog();
                },
              ),
            ),
            XtmCell(
              label: '身份证号',
              value: _userInfo.identityCard,
              rightWidget: XtmTextButton(
                text: '修改',
                height: 40,
                onPressed: () {
                  showEditDialog(
                    '身份证号',
                    _userInfo.identityCard,
                    validator: (value) {
                      if (!StringUtils.verifyCardId(value)) {
                        return '身份证号格式有误，请重新输入';
                      }
                      return null;
                    },
                  ).then((cardNum) {
                    if (cardNum != _userInfo.identityCard) {
                      updateIdCard(cardNum);
                    }
                  });
                },
              ),
            ),
            XtmCell(
              label: '登录密码',
              showDivider: false,
              rightWidget: XtmTextButton(
                text: '修改',
                height: 40,
                onPressed: () {
                  showEditPwdDialog();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> showEditDialog(
    String label,
    String value, {
    FormFieldValidator<String> validator,
  }) async {
    TextEditingController _controller = TextEditingController();
    _controller.text = value;
    final _formKey = GlobalKey<FormState>();
    await XtmConfirmDialog.show(
      context,
      title: '修改${label}',
      rightBtnTitle: '确认修改',
      formKey: _formKey,
      customContent: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Form(
            key: _formKey,
            child: XtmInput(
              label: label,
              controller: _controller,
              validator: validator,
              clear: true,
            ),
          ),
        ),
      ),
    );
    return _controller.text.trim();
  }

  void showEditPhoneDialog() {
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _codeController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    XtmConfirmDialog.show(
      context,
      title: '修改手机号',
      rightBtnTitle: '确认修改',
      formKey: _formKey,
      customContent: UpdatePhoneDialogContent(
        _userInfo.mobile,
        _phoneController,
        _codeController,
        _formKey,
      ),
    ).then((value) {
      xtmApi.mine
          .updatePhone(_phoneController.text.trim(), _codeController.text.trim())
          .then((value) {
        dataChanged = true;
        XtmToast.success('手机号修改成功');
        setState(() {
          _userInfo.mobile = _phoneController.text.trim();
        });
      });
    });
  }

  void showEditPwdDialog() {
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: UpdatePwdDialogContent(
          phone: _userInfo.mobile,
          formKey: _formKey,
          onConfirmed: (bool isForgetPwd, String smsCode, String oldPwd, String newPwd) {
            if (!_formKey.currentState.validate()) {
              return;
            }
            if (isForgetPwd) {
              xtmApi.mine.resetPwd(smsCode, newPwd).then((value) {
                XtmToast.success('密码修改成功');
                resetLoginState();
              });
            } else {
              xtmApi.mine.updatePwd(oldPwd, newPwd).then((value) {
                XtmToast.success('密码修改成功');
                resetLoginState();
              });
            }
          },
        ),
      ),
    );
  }

  void updateName(String name) {
    xtmApi.mine.updateUserName(name).then((value) {
      setState(() {
        _userInfo.name = name;
        dataChanged = true;
        XtmToast.success('修改成功');
      });
    });
  }

  void updateIdCard(String idCardNum) {
    xtmApi.mine.updateIdCardNum(idCardNum).then((value) {
      setState(() {
        _userInfo.identityCard = idCardNum;
        dataChanged = true;
        XtmToast.success('修改成功');
      });
    });
  }

  void resetLoginState() {
    xtmGlobalStore.auth.setIsLogin(false);
    xtmGlobalStore.auth.setPassword('');
    Navigator.of(context).pushReplacementNamed(AppRouterNameConstant.LOGIN);
  }
}
