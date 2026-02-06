import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_proj/config/api_interface_config/index.dart';
import 'package:flutter_proj/constants/login_constants.dart';
import 'package:flutter_proj/models/login/user_info_model.dart';
import 'package:flutter_proj/network/http_config.dart';
import 'package:flutter_proj/network/http_server_domain.dart';
import 'package:flutter_proj/routes/app_router_constant.dart';
import 'package:flutter_proj/store/global_store.dart';
import 'package:flutter_proj/theme/xtm_color.dart';
import 'package:flutter_proj/utils/async_utils.dart';
import 'package:flutter_proj/utils/countdown_util.dart';
import 'package:flutter_proj/utils/string_utils.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import 'package:flutter_proj/device/index.dart';

import 'register_page.dart';
import 'setting_password_page.dart';
import 'widgets/show_user_agreement_dialog.dart';
import 'widgets/user_notice_dialog.dart';
import 'widgets/user_use_agreement_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<String> _platformNames = [];
  String _selectedPlatformName = '';
  String _loginType = LoginConstants.LOGIN_TYPE_MOBILE;
  String versionCode = '';
  bool _agreementSelected = false;
  bool isShowSecretDialog = true;
  bool pwdObscureText = true;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormFieldState> _mobileKey = GlobalKey<FormFieldState>();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();
  CountdownTimerUtil _countdownTimer;

  @override
  void initState() {
    super.initState();
    _countdownTimer = CountdownTimerUtil();
    initBaseData();
    initInputDefaultValue();
    initVersionCode();
    checkVersion();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      agreementHandler();
    });
  }

  void checkVersion() {
    xtmApi.auth.checkVersion();
  }

  void initBaseData() {
    _platformNames = HttpServerDomain.getServerDomainNameList();
    setState(() {
      _selectedPlatformName = HttpServerDomain.getDefaultServerDomainModel().platformName;
    });
  }

  void initInputDefaultValue() {
    String userName = xtmGlobalStore.auth.userName;
    String password = xtmGlobalStore.auth.password;
    _mobileController.text = userName;
    if (_loginType == LoginConstants.LOGIN_TYPE_MOBILE) {
      _pwdController.text = password;
    }
    setState(() {});
  }

  void initVersionCode() async {
    String _versionCode = await xtmDevice.deviceInfo.getAppVersion();
    setState(() {
      versionCode = _versionCode;
    });
  }

  Future<void> agreementHandler() {
    return AsyncUtils.PromiseFunction<String>((promise) async {
      if (xtmGlobalStore.auth.showSecretDialog) {
        UserNoticeDialog.showProtocolView().then((val) {
          promise.complete();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        child: buildContentWidget(),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget buildContentWidget() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/login/login_bg.png'),
        ),
      ),
      child: Column(
        children: [
          Expanded(child: displayBodyContent()),
          buildVersionText(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildVersionText() {
    return Text(versionCode, style: TextStyle(fontSize: 12, color: XtmColor.themeColor));
  }

  Widget displayBodyContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 100),
            _buildTitle(),
            SizedBox(height: 30),
            _buildPlatformContent(),
            SizedBox(height: 30),
            _buildLoginType(),
            SizedBox(height: 10),
            _displayMobile(),
            SizedBox(height: 10),
            _loginType == LoginConstants.LOGIN_TYPE_MOBILE ? _displayPwd() : buildSMSCodeInput(),
            SizedBox(height: 15),
            UserUseAgreementWidget(
              isSelected: _agreementSelected,
              checkCallback: (bool isCheck) {
                _agreementSelected = isCheck;
              },
            ),
            SizedBox(height: 30),
            XtmTextButton(
              text: '登录',
              width: double.infinity,
              fontSize: 16,
              onPressed: () => tapLoginBtn(),
            ),
            SizedBox(height: 15),
            buildRegisterBtn(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '欢迎您登录',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text('小铁马9MS平台', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(width: 6),
            Image.asset('assets/images/login/icon_driver.png', width: 48)
          ],
        )
      ],
    );
  }

  Widget _buildPlatformContent() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: XtmColor.themeColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: XtmCell(
        label: _selectedPlatformName,
        showDivider: false,
        verticalPadding: 10,
        rightWidget: Icon(Icons.keyboard_arrow_down, size: 20, color: XtmColor.gray),
        onCellTap: () {
          XtmBottomSheet.showBottomPicker(
            context,
            title: '选择基地',
            selectItem: _selectedPlatformName,
            data: _platformNames,
          ).then((index) {
            HTTPConfig.updateDomainByPlatformName(_platformNames[index]);
            setState(() {
              _selectedPlatformName = _platformNames[index];
            });
          });
        },
      ),
    );
  }

  Widget _buildLoginType() {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _loginType = LoginConstants.LOGIN_TYPE_MOBILE;
              _formKey.currentState.reset();
            });
          },
          child: Text(
            '密码登录',
            style: TextStyle(
              color: _loginType == LoginConstants.LOGIN_TYPE_MOBILE
                  ? XtmColor.themeColor
                  : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 20),
        TextButton(
          onPressed: () {
            setState(() {
              _loginType = LoginConstants.LOGIN_TYPE_SMS;
              _formKey.currentState.reset();
            });
          },
          child: Text(
            '验证码登录',
            style: TextStyle(
              color:
                  _loginType == LoginConstants.LOGIN_TYPE_SMS ? XtmColor.themeColor : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Widget _displayMobile() {
    return XtmInput(
      formFieldKey: _mobileKey,
      label: '手机号码',
      inputType: TextInputType.number,
      clear: true,
      controller: _mobileController,
      maxSize: 11,
      inputFormatters: [XtmInputFormatter.numbersOnly],
      validator: (value) {
        if (value.trim().isEmpty) {
          return '请输入手机号码';
        }
        if (!StringUtils.isPhoneNum(value.trim())) {
          return '请输入正确的手机号码';
        }
        return null;
      },
    );
  }

  Widget _displayPwd() {
    return XtmInput(
      label: '密码',
      inputType: TextInputType.visiblePassword,
      controller: _pwdController,
      obscureText: pwdObscureText,
      suffix: newEyeButton(),
    );
  }

  Widget newEyeButton() {
    String imageName = 'login_eye_close.png';
    if (!pwdObscureText) {
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
          pwdObscureText = !pwdObscureText;
        });
      },
    );
  }

  Widget buildSMSCodeInput() {
    return XtmInput(
      label: '验证码',
      controller: _smsCodeController,
      inputType: TextInputType.number,
      clear: true,
      inputFormatters: [XtmInputFormatter.numbersOnly],
      suffix: ValueListenableBuilder(
        valueListenable: _countdownTimer.remainingSeconds,
        builder: (BuildContext context, int value, Widget child) {
          return GestureDetector(
            onTap: () {
              if (_countdownTimer.canSend) {
                requestSMSCode();
              }
            },
            child: Text(
              _countdownTimer.displayText,
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
          );
        },
      ),
    );
  }

  Widget buildRegisterBtn() {
    return GestureDetector(
      child: Text(
        '注册成为司机',
        style: TextStyle(
          color: XtmColor.themeColor,
          decoration: TextDecoration.underline,
        ),
      ),
      onTap: () {
        navigateToRegisterPage();
      },
    );
  }

  void tapLoginBtn() {
    int receiveCount = xtmGlobalStore.system.receiveCount;
    if (receiveCount != null && receiveCount > 0 && receiveCount < 100) {
      XtmToast.info('正在下载中，请稍后再试，已下载$receiveCount%');
    } else {
      FocusManager.instance.primaryFocus.unfocus();
      loginAction();
    }
  }

  void showUserAgreementDialog() {
    ShowUserAgreementDialog.showAgreementDialog(context, () {
      setState(() {
        _agreementSelected = true;
      });
    });
  }

  void requestSMSCode() {
    if (!_mobileKey.currentState.validate()) {
      return;
    }
    xtmGlobalStore.auth.setToken(HTTPConfig.baseToken);
    xtmApi.auth
        .getAuthTokenByMobileApi(mobile: _mobileController.text.trim())
        .then((value) => _countdownTimer.start());
  }

  void loginAction() async {
    if (!_agreementSelected) {
      showUserAgreementDialog();
      return;
    }
    if (!_formKey.currentState.validate()) {
      return;
    }
    xtmGlobalStore.auth.setToken(HTTPConfig.baseToken);

    Map<String, dynamic> loginParam = {};
    loginParam['mobile'] = _mobileController.text.trim();
    loginParam['password'] = _pwdController.text.trim();
    loginParam['messageCode'] = _smsCodeController.text.trim();
    loginParam['loginTypeCode'] = _loginType;
    loginParam['hardwareInformation'] = '';
    xtmApi.auth.loginByMobile(params: loginParam).then((res) => handleToken(res));
  }

  void handleToken(Map<String, dynamic> res) async {
    var token = res['header']['token'];
    if (token != null) {
      xtmGlobalStore.auth.setToken(token);
    }
    xtmGlobalStore.auth.setIsLogin(true);
    handleUserInfo(res['body']['content']['userInfo']);
    loginStatusSetting();
  }

  void handleUserInfo(Map<String, dynamic> res) {
    xtmGlobalStore.auth.setUserName(_mobileController.text.trim());
    if (_loginType == LoginConstants.LOGIN_TYPE_MOBILE) {
      xtmGlobalStore.auth.setPassword(_pwdController.text.trim());
    }
    UserInfoModel userInfo = UserInfoModel.fromJson(res);
    if (userInfo != null) {
      xtmGlobalStore.auth.setUserInfo(userInfo);
    }
  }

  void loginStatusSetting() {
    if (_loginType == LoginConstants.LOGIN_TYPE_SMS) {
      checkExistsPwdRequest();
    } else {
      changeRootPageAndLoginStatus();
    }
  }

  void checkExistsPwdRequest() {
    String userId = xtmGlobalStore.auth.userInfo.id;
    xtmApi.auth.isLoginPwdExists(userId: userId).then((res) {
      if (res) {
        changeRootPageAndLoginStatus();
      } else {
        pushToSettingPwdPage();
      }
    });
  }

  void pushToSettingPwdPage() {
    UserInfoModel userInfo = xtmGlobalStore.auth.userInfo;
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return SettingPasswordPage(userId: userInfo.id, mobile: _mobileController.text.trim());
    }));
  }

  void changeRootPageAndLoginStatus() async {
    Navigator.pushReplacementNamed(context, AppRouterNameConstant.MAIN);
  }

  void navigateToRegisterPage() {
    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      return RegisterPage();
    }));
  }

  @override
  void dispose() {
    super.dispose();
    _mobileController.dispose();
    _pwdController.dispose();
    _smsCodeController.dispose();
    _countdownTimer.stop();
  }
}
